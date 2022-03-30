% Run code review tool
[chk,qualityMetrics] = testCase.verifyWarningFree(@() ...
    certiflab.MATLAB.evaluateCodeQuality(testCase.destinationFolder,"generateReport",false));
% Check code review results
testCase.verifyEqual(chk,certiflab.tools.testStatus.PASSED);
testCase.verifyEqual(qualityMetrics.fileName,codeToCheck)
testCase.verifyEqual(qualityMetrics.filePath,fullfile(testCase.destinationFolder,codeToCheck))
testCase.verifyEqual(qualityMetrics.nbLines,5)
testCase.verifyEqual(qualityMetrics.ratioComment,60)
testCase.verifyEqual(qualityMetrics.cyclomaticComplexity,1)
testCase.verifyEqual(qualityMetrics.nbTODO,0)
testCase.verifyEqual(qualityMetrics.nbError,0)
testCase.verifyEqual(qualityMetrics.Copyright,true)
testCase.verifyEqual(qualityMetrics.Quality,true)
testCase.verifyEqual(qualityMetrics.TODOmsg,{[""]})
testCase.verifyTrue(isa(qualityMetrics.Checksum,"string"))
testCase.verifyTrue(isa(qualityMetrics.LastModification,"datetime"))
end
