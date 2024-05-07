import { expect, test} from '@jest/globals';
import { K8s, kind } from "kubernetes-fluent-client";
import { zarfExec, retry } from "../common";

test('test kicking off a pipeline run', async () => {
    // Get the root password for GitLab
    const rootPasswordSecret = await K8s(kind.Secret).InNamespace("gitlab").Get("gitlab-gitlab-initial-root-password")
    const rootPassword = atob(rootPasswordSecret.data!.password)
    const arch = process.env.UDS_ARCH
    // Create a test repository in GitLab using Zarf
    zarfExec(["package", "create", "package", "--confirm"]);
    zarfExec([
        "package",
        "mirror-resources",
        `zarf-package-gitlab-runner-test-${arch}-0.0.1.tar.zst`,
        "--git-url", "https://gitlab.uds.dev/",
        "--git-push-username", "root",
        "--git-push-password", rootPassword,
        "--confirm"
    ]);
    
    // Get the toolbox pod and add a token to the root GitLab user
    const tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${new Date()}`
    const toolboxPods = await K8s(kind.Pod).InNamespace("gitlab").WithLabel("app", "toolbox").Get()
    const toolboxPod = toolboxPods.items.at(0)
    zarfExec(["tools",
        "kubectl",
        "--namespace", "gitlab",
        "exec",
        "-i",
        toolboxPod?.metadata?.name!,
        "--",
        `gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api', 'admin_mode'], name: 'Root Test Token', expires_at: 1.days.from_now); token.set_token('${tokenName}'); token.save!"`
     ]);
    
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    // Un-protect the runner so that it picks up jobs from the `zarf-` branches
    const runnerIDResp = await (await fetch(`https://gitlab.uds.dev/api/v4/runners/all`, { headers  })).json()
    const runnerID = runnerIDResp[0].id
    const runnerResp = await fetch(`https://gitlab.uds.dev/api/v4/runners/${runnerID}`, {
        headers: [
            ["PRIVATE-TOKEN", tokenName],
            ["Content-Type", "application/x-www-form-urlencoded"]
        ],
        body: "access_level=not_protected",
        method: "put"
    })
    expect(runnerResp.status).toBe(200)

    // Check that the pipeline actually ran successfully
    let foundTheKitteh = await retry(async () => {
        const jobIDResp = await (await fetch(`https://gitlab.uds.dev/api/v4/projects/1/jobs`, { headers })).json()

        // Print the job response (useful for debugging)
        console.log(jobIDResp)

        if (jobIDResp.length > 0 && jobIDResp[0].status === "success") {
            const jobID = jobIDResp[0].id
            const jobLog = await (await fetch(`https://gitlab.uds.dev/api/v4/projects/1/jobs/${jobID}/trace`, { headers })).text()

            // Print the job log (useful for debugging)
            console.log(jobLog)

            if (jobLog.indexOf("Hello Kitteh") > -1) {
                return true
            }
        }
        return false
    }, 7, 7000);
    expect(foundTheKitteh).toBe(true)

}, 90000);
