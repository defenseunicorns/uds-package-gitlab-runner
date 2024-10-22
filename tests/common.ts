/**
 * Copyright 2024 Defense Unicorns
 * SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial
 */

import { spawnSync } from "child_process";

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
