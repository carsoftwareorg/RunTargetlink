import * as core from "@actions/core";

export interface Options {
    strBuildOption: string;
    strModelName: string;
    strProjectPath: string;
    strTargetDirPath: string;
};

export function create(): Options {
    return {
        strBuildOption: core.getInput("build_option"),
        strModelName: core.getInput("modelname"),
        strProjectPath: core.getInput("project_path"),
        strTargetDirPath: core.getInput("target_dir"),
    };
}

export function matlabString(options: Options): string {

    const params = Object.entries(options).map(function([key, value]) {
        if (typeof value == "string") {
            return `${key}='${value}'`;
        } else {
            return `${key}=${value}`;
        }
    });

    return `${params.join('; ')}`;
}