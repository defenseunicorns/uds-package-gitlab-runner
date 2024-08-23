import { expect, test} from '@jest/globals';
import * as common from "../common";
import * as path from 'path';


test('podman fails', async () => {
    // millis is used through the tests to have a unique id
    // this is handy so you can rerun the tests against an existing
    // insance of gitlab and it will continue to make new projects 
    // and you don't have to clean up or redeploy when iterating on local testing
    const nowMillis = Date.now();

    // Get the toolbox pod and add a token to the root GitLab user
    const tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${nowMillis}`

    await common.createToken(nowMillis, tokenName);

    const sourceRepoName = 'podman'
    const gitProjectName = `${sourceRepoName}-${nowMillis}`
    const gitRepoDir = path.join(__dirname, 'tmp-repos', gitProjectName)
    const sourceDir = path.join(__dirname, 'repo-sources', sourceRepoName)

    common.createNewGitlabProject(gitRepoDir, sourceDir, tokenName, gitProjectName);
  
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    // get the project id using the project name
    const projectId = await common.getGitlabProjectId(gitProjectName, headers);

    console.log(`Found now project id [${projectId}]`)

    await common.unprotectRunner(headers, tokenName);

    // Check that the pipeline failed as expected
    const expectedStatus = "failed"
    const expectedJobLogOutputs: string[] = []; // nothing expected on this one, just looking for a failure
    await common.checkJobResults(projectId, headers, expectedJobLogOutputs, expectedStatus);
}, 90000);

test('podman succeeds', async () => {
    // millis is used through the tests to have a unique id
    // this is handy so you can rerun the tests against an existing
    // insance of gitlab and it will continue to make new projects 
    // and you don't have to clean up or redeploy when iterating on local testing
    const nowMillis = Date.now();

    // Get the toolbox pod and add a token to the root GitLab user
    const tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${nowMillis}`

    await common.createToken(nowMillis, tokenName);

    const sourceRepoName = 'podman'
    const gitProjectName = `${sourceRepoName}-${nowMillis}`
    const gitRepoDir = path.join(__dirname, 'tmp-repos', gitProjectName)
    const sourceDir = path.join(__dirname, 'repo-sources', sourceRepoName)

    common.createNewGitlabProject(gitRepoDir, sourceDir, tokenName, gitProjectName);
  
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    // get the project id using the project name
    const projectId = await common.getGitlabProjectId(gitProjectName, headers);

    console.log(`Found now project id [${projectId}]`)

    await common.unprotectRunner(headers, tokenName);

    // Check that the pipeline failed as expected
    const expectedStatus = "success"
    const expectedJobLogOutputs: string[] = ['STEP 1/2: FROM scratch', 'STEP 2/2: ADD test.txt /', 'COMMIT']; 
    await common.checkJobResults(projectId, headers, expectedJobLogOutputs, expectedStatus);
}, 90000);

test('hello kitteh succeeds', async () => {
    // millis is used through the tests to have a unique id
    // this is handy so you can rerun the tests against an existing
    // insance of gitlab and it will continue to make new projects 
    // and you don't have to clean up or redeploy when iterating on local testing
    const nowMillis = Date.now();

    // Get the toolbox pod and add a token to the root GitLab user
    const tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${nowMillis}`

    await common.createToken(nowMillis, tokenName);

    const sourceRepoName = 'kitteh'
    const gitProjectName = `${sourceRepoName}-${nowMillis}`
    const gitRepoDir = path.join(__dirname, 'tmp-repos', gitProjectName)
    const sourceDir = path.join(__dirname, 'repo-sources', sourceRepoName)

    common.createNewGitlabProject(gitRepoDir, sourceDir, tokenName, gitProjectName);
  
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    // get the project id using the project name
    const projectId = await common.getGitlabProjectId(gitProjectName, headers);

    console.log(`Found now project id [${projectId}]`)

    await common.unprotectRunner(headers, tokenName);

    // Check that the pipeline actually ran successfully
    const expectedStatus = "success"
    const expectedJobLogOutputs: string[] = ['Hello Kitteh']; 
    await common.checkJobResults(projectId, headers, expectedJobLogOutputs, expectedStatus);

}, 90000);
