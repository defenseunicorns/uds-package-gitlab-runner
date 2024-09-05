import { expect, test} from '@jest/globals';
import { K8s, kind } from "kubernetes-fluent-client";
import { zarfExec, retry } from "../common";
import * as path from 'path';
import { execSync } from 'child_process';
import { rm } from 'fs/promises';

const domainSuffix = process.env.DOMAIN_SUFFIX || ".uds.dev"

test('hello kitteh succeeds', async () => {
    const sourceRepoName = 'kitteh'
    const expectedStatus = 'success'
    const expectedJobLogOutputs: string[] = ['Hello Kitteh']

    await executeTest(sourceRepoName, expectedJobLogOutputs, expectedStatus)
}, 90000);


test('podman succeeds', async () => {
    const sourceRepoName = 'podman'
    const expectedStatus = 'success'
    const expectedJobLogOutputs: string[] = ['STEP 1/2: FROM scratch', 'STEP 2/2: ADD test.txt /', 'COMMIT']

    await executeTest(sourceRepoName, expectedJobLogOutputs, expectedStatus)
}, 90000);


test('podman fails', async () => {

    const sourceRepoName = 'podman'
    const expectedStatus = 'failed'
    const expectedJobLogOutputs: string[] = []

    await executeTest(sourceRepoName, expectedJobLogOutputs, expectedStatus)
}, 90000);


async function executeTest(sourceRepoName: string, expectedJobLogOutputs: string[], expectedStatus: string) {
    const nowMillis = Date.now()
    const tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${nowMillis}`    
    
    var sourceDir = path.join(__dirname, 'repo-sources', sourceRepoName)

    // Get the toolbox pod and add a token to the root GitLab user
    await createToken(tokenName, nowMillis)
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    const gitLabProjectName = `${sourceRepoName}-${nowMillis}`
    const projectId = await createNewGitlabProject(sourceDir, tokenName, gitLabProjectName, headers)
    
    await unprotectRunner(headers, tokenName)

    // Check that the pipeline ran as expected
    await checkJobResults(projectId, headers, expectedJobLogOutputs, expectedStatus)
}


async function createToken(tokenName: string, nowMillis: number) {
    const toolboxPods = await K8s(kind.Pod).InNamespace("gitlab").WithLabel("app", "toolbox").Get()
    const toolboxPod = toolboxPods.items.at(0)
    zarfExec(["tools",
        "kubectl",
        "--namespace", "gitlab",
        "exec",
        "-i",
        toolboxPod?.metadata?.name!,
        "--",
        `gitlab-rails runner "token = User.find_by_username('root').personal_access_tokens.create(scopes: ['api', 'admin_mode', 'read_repository', 'write_repository'], name: 'Root Test Token ${nowMillis}', expires_at: 1.days.from_now); token.set_token('${tokenName}'); token.save!"`
    ]);
}

async function createNewGitlabProject(sourceDir: string, tokenName: string, gitLabProjectName: string, headers: HeadersInit) {
    await deleteDirectory(path.join(sourceDir, '.git')) 
    execSync('git init', { cwd: sourceDir })
    execSync('git add . ', { cwd: sourceDir })
    execSync('git config commit.gpgsign false', { cwd: sourceDir }) // need this so that gpg signing doesn't attempt to happen locally when running tests
    execSync('git commit -m "Initial commit" ', { cwd: sourceDir })
    execSync(`git remote add origin https://root:${tokenName}@gitlab${domainSuffix}/root/${gitLabProjectName}.git`, { cwd: sourceDir })
    execSync('git push -u origin --all', { cwd: sourceDir })
    await deleteDirectory(path.join(sourceDir, '.git'))

    console.log(`Finding project id for project name [${encodeURIComponent(gitLabProjectName)}]`)
    const projectResp = await fetch(`https://gitlab${domainSuffix}/api/v4/projects?search=${encodeURIComponent(gitLabProjectName)}`, { headers })
    const projects = await projectResp.json()

    const project = projects.find((p: { name: string; }) => p.name === gitLabProjectName)
    const projectId = project?.id
    console.log(`Found project id [${projectId}]`)
    return projectId
}

async function unprotectRunner(headers: HeadersInit, tokenName: string) {
    const runnerIDResp = await (await fetch(`https://gitlab${domainSuffix}/api/v4/runners/all`, { headers })).json()
    const runnerID = runnerIDResp[0].id
    const runnerResp = await fetch(`https://gitlab${domainSuffix}/api/v4/runners/${runnerID}`, {
        headers: [
            ["PRIVATE-TOKEN", tokenName],
            ["Content-Type", "application/x-www-form-urlencoded"]
        ],
        body: "access_level=not_protected",
        method: "put"
    });
    expect(runnerResp.status).toBe(200)
}

async function checkJobResults(projectId: any, headers: HeadersInit, expectedJobLogOutputs: string[], expectedStatus: string) {
    let status = await retry(async () => {
        const jobIDResp = await (await fetch(`https://gitlab${domainSuffix}/api/v4/projects/${projectId}/jobs`, { headers })).json()

        // Print the job response (useful for debugging)
        console.log(jobIDResp)

        if (jobIDResp.length > 0 && (jobIDResp[0].status === "success" || jobIDResp[0].status === "failed")) {
            const jobID = jobIDResp[0].id;
            const jobLog = await (await fetch(`https://gitlab${domainSuffix}/api/v4/projects/${projectId}/jobs/${jobID}/trace`, { headers })).text()

            // Print the job log (useful for debugging)
            console.log(jobLog)

            expectedJobLogOutputs.forEach( expectedOutput => {
                expect(jobLog).toContain(expectedOutput)
            });
            return jobIDResp[0].status
        }
        return false
    }, 20, 5000);
    expect(status).toBe(expectedStatus)
}

async function deleteDirectory(path: string) {
    try {
        await rm(path, { recursive: true, force: true })
        console.log(`Directory ${path} has been deleted successfully.`)
    } catch (error) {
        console.error(`Error while deleting directory ${path}:`, error)
    }
}
