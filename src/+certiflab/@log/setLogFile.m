function setLogFile(obj,logFile)
%setLogFile Change the location of the text log file.
%
% The Method setLogFile allows user to change the log file name with an
% appropriate file path
%
%   INPUTS:
%       logFile     Name or full path of desired logfile defined
%                   as string scalar. It define log file path
%                   (absolute or relative) with the appropriate extension (".txt" ,
%                   ".dat", ".data", ".log") described as a string scalar
%   OUTPUTS
%       N/A
%
%   Example
%   obj = certiflab.log()
%   obj.setFilename("C:\temp\log.txt");
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

% I/O MANAGEMENT:

% class
certiflab.check.checkStringScalar(logFile,"ErrorID","log:LogFile:badClass","VariableName","LogFile");

% extension
certiflab.check.checkExtension(logFile,obj.listLogExtension,"ErrorID","log:LogFile:badExtension");

% folder
logFolderPath = fileparts(logFile);

%create folder if it does not exist
if not(isfolder(logFolderPath))
    certiflab.tools.createFolder(logFolderPath,"ErrorID", "setLogFile:folderCreation:impossible");
end

% EXECUTION :

%create a file with append

[fid,message] = fopen(logFile, 'a');
if(fid < 0)
    ME = certiflab.exception.createException("setLogFile:folderCreation:impossible",...
        sprintf("The file %s shall be created with fopen",logFile),...
        sprintf("Problem to create logfile [%s].\nCurrent System message:\n%s ",logFile,message));
    
    %raise error
    error(ME.identifier,ME.message);
end
fclose(fid);


%update the object
obj.logFile = logFile;

end

%------------- END OF CODE --------------