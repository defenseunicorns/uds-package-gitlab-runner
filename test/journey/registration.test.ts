import { expect, test} from '@jest/globals';
import { K8s, kind } from "kubernetes-fluent-client";
import { spawnSync } from "child_process";

test('test registration of the runner succeeded', async () => {
    let foundRegistrationSuccess = false
    for (let i = 0; i < 3; i++) {
        await new Promise(r => setTimeout(r, 3000))
        const runnerPods = await K8s(kind.Pod).InNamespace("gitlab-runner").WithLabel("app", "gitlab-runner").Get()
        if (runnerPods.items.at(0)?.status?.phase === "Running") {
            const podName = runnerPods.items.at(0)?.metadata?.name
            const runnerLogs = spawnSync(
                `uds zarf tools kubectl logs -n gitlab-runner ${podName} -c gitlab-runner`, {
                shell: true, // Run command in a shell
            });
            if (runnerLogs.stdout.indexOf("Registering runner... succeeded") > -1) {
                foundRegistrationSuccess = true
            }
        }
    }
    expect(foundRegistrationSuccess).toBe(true)
}, 30000);
