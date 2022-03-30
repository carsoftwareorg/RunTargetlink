
function md5 = getFileChecksum( filePath )
%GETFILECHECKSUM - calculate the MD5 checksum based on the Simulink tools
%
%   Syntax:
%       md5 = getFileChecksum( filePath ) - calculate the MD5 checksum based on the Simulink tools
%         
%   Inputs:
%       filePath    - path (relative or absolute) of the files as a
%                   string vector
%
%   Outputs:
%       md5         - checkSum of the files as a string vector if the
%                   filePath is empty or if the file does not exist the checksum will be ""
%
%   examples: 
%       certiflab.tools.getFileChecksum("c:\test001.m")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT

certiflab.check.checkStringVector(filePath,"VariableName","filePath","ErrorID","getFileChecksum:filePath:badClass");


%% EXECUTION

idxFile = isfile(filePath);

md5 = strings(length(filePath),1);

md5(idxFile) = arrayfun(@(v) string(Simulink.getFileChecksum(char(v))), filePath(idxFile));


end

%------------- END OF CODE --------------
