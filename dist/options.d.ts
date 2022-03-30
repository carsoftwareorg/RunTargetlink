export interface Options {
    strBuildOption: string;
    strModelName: string;
    strProjectPath: string;
    strTargetDirPath: string;
}
export declare function create(): Options;
export declare function matlabString(options: Options): string;
