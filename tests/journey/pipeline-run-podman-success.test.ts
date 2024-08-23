import { expect, test} from '@jest/globals';
import * as common from "../common";
import * as path from 'path';

// source directory from 'journey/repo-sources' that will be used to
// populate a new git repo and upload contents to gitlab as a new project
const sourceRepoName = 'podman'

var nowMillis:number;
var tokenName:string;
var gitProjectName:string;
var gitRepoDir:string;
var sourceDir:string;

beforeAll(() => {
    // millis is used through the tests to have a unique id
    // this is handy so you can rerun the tests against an existing
    // insance of gitlab and it will continue to make new projects 
    // and you don't have to clean up or redeploy when iterating on local testing
    nowMillis = Date.now();

    tokenName = `if-you-see-me-in-production-something-is-horribly-wrong-${nowMillis}`
    gitProjectName = `tmp-${sourceRepoName}-${nowMillis}`

    gitRepoDir = path.join(__dirname, 'tmp-repos', gitProjectName)
    sourceDir = path.join(__dirname, 'repo-sources', sourceRepoName)
});
  
afterAll(async () => {
    await common.deleteDirectory(gitRepoDir) // delete the temp dir so it doesn't accumulate locally
});


test('podman succeeds', async () => {

    // Get the toolbox pod and add a token to the root GitLab user
    await common.createToken(nowMillis, tokenName);
    common.createNewGitlabProject(gitRepoDir, sourceDir, tokenName, gitProjectName);
  
    const headers: HeadersInit = [["PRIVATE-TOKEN", tokenName]]

    // get the project id using the project name
    const projectId = await common.getGitlabProjectId(gitProjectName, headers);

    console.log(`Found now project id [${projectId}]`)

    await common.unprotectRunner(headers, tokenName);

    // Check that the pipeline actually ran successfully
    const expectedStatus = "success"
    const expectedJobLogOutputs: string[] = ['STEP 1/2: FROM scratch', 'STEP 2/2: ADD test.txt /', 'COMMIT']; 
    await common.checkJobResults(projectId, headers, expectedJobLogOutputs, expectedStatus);

}, 90000);
