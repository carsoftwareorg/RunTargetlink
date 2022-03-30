function [status,result] = runMATLABTest(folder2test,varargin)
%%runMATLABTest run Matlab test cases and generate report
%
%   SYNTAX
%       status = runMATLABTest(folder2test) run all the test cases of the
%       folder folder2test.
%
%   INPUTS ARGUMENTS:
%       folder2test absolute or relative path of the folder to analyze
%                   defined as a string scalar. Folder shall exist.
%
%   OUTPUTS ARGUNMENTS:
%       status      testStatus logical enumerate with value of FAILED or PASSED
%
%       result      A matlab.unittest.TestResult object containing the result of the test run.
%                   result is the same size as suite and each element is the result of the
%                   corresponding element in suite.
%
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "ArtefactFolder"    : Artefact location defined as string scalar
%                           (default: current folder). Folder is created if not existing
%
%       "RunName"           : string scalar to definie the prefix name of all
%                           artefacts  (by default : CodeTestReport)
%
%       "CreateReport"      : (logical) produce HTML report (false by
%                           default) - LONG DURATION
%
%       "EvaluateCoverage"  : (logical) produce HTML report about the Matlab coverage (true by default)
%
%       "SRCFolder"         : Source location defined as string scalar used
%                           only for coverage analysis. (default: "")
%
%       "CreateJUnit"       : (logical) produce Junit artefact (default: false)
%
%       "CreateTAP"         : (logical) produce TAP artefact (default: false)
%
%       "Log"               : (certiflab.log) log file associated to
%                             certiflab
%
%   EXAMPLES:
%       a =certiflab.MATLAB.runMATLABTest("C:\TEST")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% IO MANAGEMENT

%folder2test
certiflab.check.checkStringScalar(folder2test,"ErrorID","runMATLABTest:folder2test:badClass","VariableName","folder2test");
certiflab.check.checkFolderExistence(folder2test,"ErrorID","runMATLABTest:folder2test:noFolder");

% transform relative to absolute path
s = what(folder2test);
folder2test = string(s.path);

%% OPTION MANAGEMENT

%create a default log
logDefault = certiflab.log();
logDefault.disableLog(); %disable log feature

% create configuraiton of the option
optionName      = ["RunName", "CreateTAP" , "ArtefactFolder", "CreateJUnit","EvaluateCoverage","SRCFolder","CreateReport","Log"];
defaultValue    = {"CodeTestReport",false,string(pwd),false,false,"",false,logDefault};

% parse varargin
opt = certiflab.tools.internal.parseVarargin(optionName,defaultValue, varargin{:});

%RunName
certiflab.check.checkStringScalar(opt.RunName,"ErrorID","runMATLABTest:RunName:badClass","VariableName","RunName");

%CreateJunit
certiflab.check.checkLogicalScalar(opt.CreateJUnit,"ErrorID","runMATLABTest:CreateJUnit:badClass","VariableName","CreateJUnit")

%EvaluateCoverage
certiflab.check.checkLogicalScalar(opt.EvaluateCoverage,"ErrorID","runMATLABTest:EvaluateCoverage:badClass","VariableName","EvaluateCoverage")

% SRCFolder
if opt.EvaluateCoverage
    % check the data type
    certiflab.check.checkStringScalar(opt.SRCFolder,"ErrorID","runMATLABTest:SRCFolder:badClass","VariableName","SRCFolder");
    
    % check folder existence
    certiflab.check.checkFolderExistence(opt.SRCFolder,"ErrorID","runMATLABTest:SRCFolder:NoFolder");
end

%CreateReport
certiflab.check.checkLogicalScalar(opt.CreateReport,"ErrorID","runMATLABTest:CreateReport:badClass","VariableName","CreateReport")

%ArtefactFolder
certiflab.check.checkStringScalar(opt.ArtefactFolder,"ErrorID","runMATLABTest:ArtefactFolder:badClass","VariableName","ArtefactFolder");

if not(isfolder(opt.ArtefactFolder))
    certiflab.tools.createFolder(opt.ArtefactFolder)
end

%% LOG MANAGMENT

log = opt.Log;

%set the log Function Name
log.setFunction("runMATLABTest","execute MATLAB unit test framework for a folder contents");

% start Function loging
log.startFunctionExecution()

log.fprintf("\t> test folder : %s\n",folder2test);


%% TOOLS
%load all packages needed for the execution of the test cases and the
%artefact generation

import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.TestReportPlugin
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.TAPPlugin
import matlab.unittest.plugins.ToFile
import matlab.unittest.plugins.*
import matlab.unittest.plugins.ToFile
import matlab.unittest.plugins.codecoverage.CoberturaFormat
import matlab.unittest.plugins.CodeCoveragePlugin
import matlab.unittest.plugins.codecoverage.CoverageReport


%% PREPARE THE RUN OF THE TEST CASES
% This section creates and feeds the runner object used for the execution
% of all test cases and the generation of the artefacts

% Creation of the global runner
runner = TestRunner.withTextOutput('OutputDetail',0);

% prepare TAP report  if needed
if opt.CreateTAP
    log.fprintf("\t> TAP report activated\n")
    resultsFile = fullfile(opt.ArtefactFolder,opt.RunName + "_TAP.tap");
    
    % create plugin
    plugin = TAPPlugin.producingVersion13(ToFile(resultsFile));
    
    % add to runner
    runner.addPlugin(plugin);
end

% JUnit Format xml file if needed
if opt.CreateJUnit
    log.fprintf("\t> JUNIT report activated\n")
    resultsFile = fullfile(opt.ArtefactFolder,opt.RunName + "_JUnit.xml");
    % Add to runner
    runner.addPlugin(XMLPlugin.producingJUnitFormat(resultsFile));
    
end

% Prepare the html file report if needed
if opt.CreateReport
    log.fprintf("\t> HTML report activated\n")
    reportPlugin = TestReportPlugin.producingHTML(fullfile(opt.ArtefactFolder,"codeVerificationReport"),...
        'IncludingPassingDiagnostics',false,...
        'IncludingCommandWindowText',false);
    runner.addPlugin(reportPlugin);
    
end

% Prepare coverage settings if needed
if opt.EvaluateCoverage
    log.fprintf("\t> Coverage report activated\n")
    % creating the coverage report path
    %resultsFile = fullfile(opt.ArtefactFolder,opt.RunName + "_coverage.html");
    
    % plugin definition
    plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(opt.SRCFolder,...
        'IncludingSubfolders',true,...
        'Producing',CoverageReport(opt.ArtefactFolder,'MainFile',opt.RunName + "_coverage.html"));
    
    % adding the plugin to the runner
    runner.addPlugin(plugin);
    
    % Cobertura
    plugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder(opt.SRCFolder,...
        'IncludingSubfolders',true,...
        'Producing',CoberturaFormat(fullfile(opt.ArtefactFolder,opt.RunName + "_coverage.xml")));
    runner.addPlugin(plugin);
end

% creation of the Test Suite
ts = matlab.unittest.TestSuite.fromFolder(folder2test);


%% RUN TESTS
% This section runs the test suite with the runner configuration

% launch test
result = runner.run(ts);

% analyze test
status = certiflab.tools.testStatus(sum([result.Failed])==0);



%% teardown

log.fprintf("\n[CERTIFLAB] - MATLAB CODE TEST\n")
log.fprintf("\t> Passed test cases           : %i / %i test cases\n",nnz(cell2mat({result.Passed})),length(result));
log.fprintf("\t> Failed test cases           : %i / %i test cases\n",nnz(cell2mat({result.Failed})),length(result));
log.fprintf("\n\t> Global test suite status    : %s\n\n",status);

% console ouptuts :
log.finish();


end
%%
% *Copyright 2020 The MathWorks, Inc.*
