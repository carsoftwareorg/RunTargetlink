function [chk,qualityMetrics] = evaluateCodeQuality(folderPath,varargin)
%EVALUATECODEQUALITY - evaluate the code quality of folder and subfolders
%
%   SYNTAX:
%       output = EVALUATECODEQUALITY(folderPath) evaluate the quality of
%       all m-file contained in the folder folderPath and the associated
%       subfolders
%
%   INPUTS:
%       folderPath  absolute or relative path of the folder to analyze
%                   defined as a string scalar. Folder shall exist.
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "ReportName", reportName        reportName provides the name of the
%                                       report used for the file creation
%                                       as string scalar. (default:
%                                       "CodeQualityReport"
%
%       "Extension", reportExtension    reportExtension provides the
%                                       extension as a string scalar. The
%                                       extension could be ".pdf",".html"
%                                       or ".htmx" (default ".htmx")
%
%       "Folder2save", folder2saved     folder2save provides the path (absolute
%                                       or relative) where to save the report as a string scalare.
%                                       The folder shall exist. (default :
%                                       current folder)
%
%       "GenerateReport", generateRPT   generateRPT, logical scalar set the
%                                       creation of the report. (default:
%                                       true)
%
%       "Log",log                       certiflab log object (default: no
%                                       log).
%
%   OUTPUTS:
%       chk         true if all the tested failed passed the quality criteria else false     
%
%   EXAMPLES:
%       certiflab.MATLAB.evaluateCodeQuality()
%       certiflab.MATLAB.evaluateCodeQuality("C:\")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

if nargin==0
    % open UI to select folder
    selPath = uigetdir;
    
    if selPath==0,return,end % user press cancel button
    
    folderPath = string(selPath);
end

%check the class of folder path
certiflab.check.checkStringScalar(folderPath)

%check the existence of the folder
certiflab.check.checkFolderExistence(folderPath)

% transform relative to absolute path
s = what(folderPath);
folderPath = string(s.path);

%% MANAGEMENT OF THE OPTION


parameterList   = ["ReportName";"Extension";"Folder2save";"GenerateReport";"Log"];

%create a default log
logDefault = certiflab.log();
logDefault.disableLog(); %disable log feature


defaultVal      = {"CodeQualityReport",...
    ".htmx",...
    string(pwd),...
    true,...
    logDefault}';

opt = certiflab.tools.internal.parseVarargin(parameterList,defaultVal, varargin{:});

%check ReportName
certiflab.check.checkStringScalar(opt.ReportName,"ErrorID","evaluateCodeQuality:ReportName:BadClass","VariableName","reportName");

% check extension
certiflab.check.checkStringScalar(opt.Extension,"ErrorID","evaluateCodeQuality:Extension:BadClass","VariableName","Extension");
certiflab.check.validString(opt.Extension,[".pdf",".html",".htmx"],"ErrorID","evaluateCodeQuality:Extension:badExtension");

% check Folder2save
certiflab.check.checkStringScalar(opt.Folder2save,"ErrorID","evaluateCodeQuality:Folder2save:BadClass","VariableName","Folder2save");
certiflab.check.checkFolderExistence(opt.Folder2save,"ErrorID","evaluateCodeQuality:Folder2save:NoFolder")

% check generateReport
certiflab.check.checkScalar(opt.GenerateReport,"ErrorID","evaluateCodeQuality:GenerateReport:BadDimension","VariableName","GenerateReport")
certiflab.check.checkDataType(opt.GenerateReport,"logical","ErrorID","evaluateCodeQuality:GenerateReport:BadClass","VariableName","GenerateReport")

%check LogDefault
certiflab.check.checkDataType(opt.Log,"certiflab.log","ErrorID","evaluateCodeQuality:Log:BadClass","VariableName","Log")


%% LOG MAANGMENT

log = opt.Log;

%set the log Function Name
log.setFunction("evaluateCodeQuality","Evaluate the KPI of MATLAB m-files");

% start Function loging
log.startFunctionExecution()

%% COLLECT ALL THE FILE
log.openTask("Collect all the m-file to assess");

% collect all m file
listFilePath       = fullfile(folderPath,'**','*.m');
listFilePath       = struct2table(dir(listFilePath));

listFilePath        = fullfile(string(listFilePath.folder),string(listFilePath.name));

% remove contents.m
listFilePath= listFilePath(not(contains(listFilePath,'Contents.m','IgnoreCase',true)));

%nb of filePath
nbFile = length(listFilePath);
log.fprintf("\t\t> Number of m-file : %i files\n",nbFile)

% console output
log.closeTask(true)

%% ASSESSMENT OF THE FILE LIST
log.openTask("Assessment of the files")

%create empty table with the appropriate size
objQuality = certiflab.MATLAB.quality(listFilePath(1));
qualityMetrics = repmat(objQuality.quality2table(),nbFile,1);


for idx = 2:nbFile
    
    objQuality              = certiflab.MATLAB.quality(listFilePath(idx));
    qualityMetrics(idx,:)   = objQuality.quality2table();
    
end

% console output
log.closeTask(true);

%% REPORT GENERATION
% decide to generate report
if opt.GenerateReport
    log.openTask("Create Code Quality Report");
    
    % check if it is possible to generate report
    try
        %create report
        generateReport(qualityMetrics,folderPath,opt);
        
        %console output
        log.closeTask(true)
    catch ME
        log.warning("evaluateCodeQuality:NoReport","Impossible to create Code quality report.\n\nSystem Message:\n%s",ME.message)
        %console output
        log.closeTask(false)
    end
end

% create the outputs (PASSED or FAILED)

chk = certiflab.tools.testStatus(all(qualityMetrics.Quality));

%% TEARDOWN

% publish result
log.fprintf("\n\t\t> Result of the Code Quality analysis :\n")
log.fprintf(  "\t\t> Passed files : %i / %i files\n", nnz(qualityMetrics.Quality),nbFile)

if any(qualityMetrics.Quality==false)
    log.fprintf("\n\t\t> List of files with detected issues :\n");
   
    listPrbFile = qualityMetrics.fileName(qualityMetrics.Quality==false);
    
    log.fprintf("\t\t\t - %s\n",listPrbFile);
else
    log.fprintf("\n");
    
end

%console output
log.finish();

end

%------------- END OF CODE --------------
