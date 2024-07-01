import { expect, test} from '@jest/globals';
import { K8s, kind } from "kubernetes-fluent-client";
import { zarfExec, retry } from "../common";

test('test registration of the runner succeeded', async () => {
    let foundRegistrationSuccess = await retry(async () => {
        const runnerPods = await K8s(kind.Pod).InNamespace("gitlab-runner").WithLabel("app", "gitlab-runner").Get()
        if (runnerPods.items.at(0)?.status?.phase === "Running") {
            const podName = runnerPods.items.at(0)?.metadata?.name!
            const runnerLogs = zarfExec(["tools", "kubectl", "logs", "-n", "gitlab-runner", podName, "-c", "gitlab-runner"], true);
            if (runnerLogs.stdout.indexOf("Runner registered successfully") > -1) {
                return true
            }
        }
        return false
    })
    expect(foundRegistrationSuccess).toBe(true)
});
