import { spawnSync } from "child_process";
import { execSync } from 'child_process';
import { K8s, kind } from "kubernetes-fluent-client";
import { rm } from 'fs/promises';
import * as fs from 'fs';
import * as path from 'path';

export function zarfExec(args: string[], captureOutput = false) {
    const argString = args.join(" ")
    return spawnSync(
        `uds zarf ${argString}`, {
        // Run command in a shell
        shell: true,
        // Print the command output directly to the shell if we don'e want to capture it (useful for debugging)
        stdio: captureOutput ? undefined : 'inherit'
    });
}

export async function retry(funcCb: Function, retries = 3, timeout = 3000) {
    let result = false
    for (let i = 0; i < retries; i++) {
        await new Promise(r => setTimeout(r, timeout))
        result = await funcCb()
        if (result) {
            break
        }
    }
    return result
}

export async function createToken(nowMillis: number, tokenName: string) {
    const toolboxPods = await K8s(kind.Pod).InNamespace("gitlab").WithLabel("app", "toolbox").Get();
    const toolboxPod = toolboxPods.items.at(0);
    console.log('Using gitlab-rails runner to configure root token');
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

export function createNewGitlabProject(gitRepoDir: string, sourceDir: string, tokenName: string, gitProjectName: string) {
    console.log(`Setting up new git repo at ${gitRepoDir}`);
    copyFilesToGitRepoDir(sourceDir, gitRepoDir);
    execSync('git init', { cwd: gitRepoDir });
    execSync('git add . ', { cwd: gitRepoDir });
    execSync('git config commit.gpgsign false', { cwd: gitRepoDir }); // need this so that gpg signing doesn't attempt to happen locally when running tests
    execSync('git commit -m "Initial commit" ', { cwd: gitRepoDir });
    execSync(`git remote add origin https://root:${tokenName}@gitlab.uds.dev/root/${gitProjectName}.git`, { cwd: gitRepoDir });
    execSync('git push -u origin --all', { cwd: gitRepoDir });
}

export async function getGitlabProjectId(gitProjectName: string, headers: HeadersInit) {
    const projectResp = await fetch(`https://gitlab.uds.dev/api/v4/projects?search=${encodeURIComponent(gitProjectName)}`, { headers });
    const projects = await projectResp.json();

    const project = projects.find((p: { name: string; }) => p.name === gitProjectName);
    const projectId = project?.id;
    return projectId;
}

export async function unprotectRunner(headers: HeadersInit, tokenName: string) {
    const runnerIDResp = await (await fetch(`https://gitlab.uds.dev/api/v4/runners/all`, { headers })).json();
    const runnerID = runnerIDResp[0].id;
    const runnerResp = await fetch(`https://gitlab.uds.dev/api/v4/runners/${runnerID}`, {
        headers: [
            ["PRIVATE-TOKEN", tokenName],
            ["Content-Type", "application/x-www-form-urlencoded"]
        ],
        body: "access_level=not_protected",
        method: "put"
    });
    expect(runnerResp.status).toBe(200);
}

export async function checkJobResults(projectId: any, headers: HeadersInit, expectedJobLogOutputs: string[], expectedStatus: string) {
    let status = await retry(async () => {
        const jobIDResp = await (await fetch(`https://gitlab.uds.dev/api/v4/projects/${projectId}/jobs`, { headers })).json();

        // Print the job response (useful for debugging)
        console.log(jobIDResp);

        if (jobIDResp.length > 0 && (jobIDResp[0].status === "success" || jobIDResp[0].status === "failed")) {
            const jobID = jobIDResp[0].id;
            const jobLog = await (await fetch(`https://gitlab.uds.dev/api/v4/projects/${projectId}/jobs/${jobID}/trace`, { headers })).text();

            // Print the job log (useful for debugging)
            console.log(jobLog);

            expectedJobLogOutputs.forEach( expectedOutput => {
                expect(jobLog).toContain(expectedOutput);
            });
            return jobIDResp[0].status;
        }
        return false;
    }, 7, 7000);
    expect(status).toBe(expectedStatus);
}

export async function deleteDirectory(path: string) {
    try {
        await rm(path, { recursive: true, force: true });
        console.log(`Directory ${path} has been deleted successfully.`);
    } catch (error) {
        console.error(`Error while deleting directory ${path}:`, error);
    }
}

function copyFilesToGitRepoDir(srcDir: string, destDir: string): void {
    // Ensure destination directory exists
    if (!fs.existsSync(destDir)) {
        fs.mkdirSync(destDir, { recursive: true });
    }

    // Read files from source directory
    const files = fs.readdirSync(srcDir);

    // Copy each file
    files.forEach(file => {
        const srcFile = path.join(srcDir, file);
        const destFile = path.join(destDir, file);

        if (fs.lstatSync(srcFile).isFile()) {
            fs.copyFileSync(srcFile, destFile);
        }
    });
}