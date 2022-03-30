import * as script from "./script";
import {Options} from "./options";

describe("command generation", () => {
    it("contains correct parameter values", () => {
        const options: Options = {
            strBuildOption: "test",
            strModelName: "test",
            strProjectPath: "test",
            strTargetDirPath: "test",
        };

        const actual = script.generateCommand(options);

        expect(actual.includes("strBuildOption='test';")).toBeTruthy();
        expect(actual.includes("strModelName='test';")).toBeTruthy();
        expect(actual.includes("strProjectPath='test';")).toBeTruthy();
        expect(actual.includes("strTargetDirPath='test';")).toBeTruthy();
        expect(actual.includes("; main;")).toBeTruthy();

    });

});