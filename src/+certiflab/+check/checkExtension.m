function checkExtension(filePath,expectedExtension,varargin)
%checkExtension - analyse filepath extension
%
%   SYNTAX:
%       checkExtension(filepath,expectedExtension) raise an error if the
%       extension of the files defined by filePath is not similar to the
%       expected extension defined by expectedExtension
%
%   INPUTS:
%
%       filePath            absolute or relative path to the file specified
%                           as a string vector (Nx1) or (1xN). N is the number 
%                           of file to test.
%
%       expectedExtension   expected extension of the files defined as a
%                           string scalar (1x1) which the first character
%                           is a point (.). This parameter is case
%                           sensitive
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkExtension:data2test:BadDimension)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "filePath") 
%
%   OUTPUTS:
%       N/A
%
%   EXAMPLES:
%       certiflab.check.checkExtension("test01.c","c")
%       certiflab.check.checkExtension(["C:\test01.c","test02.c"],[".c" "cc"] )
%
%   See also: N/A

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT


%file path
certiflab.check.checkStringVector(filePath,"ErrorID","checkExtension:filePath:BadClass","VariableName","filePath");

% extension
certiflab.check.checkStringVector(filePath,"ErrorID","checkExtension:expectedExtension:BadClass","VariableName","expectedExtension");
assert(all(strncmpi(expectedExtension,".",1)),"checkExtension:INPUT:expectedExtension:NotExtension",...
    "all extension shall start by a point (""."")\n current list:\n%s",sprintf("\t-""%s""\n",expectedExtension));

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkExtension:BadExtension","filePath"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkExtension:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkExtension:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));



%% EXECUTION
%init
nbFile = length(filePath);
validExtension = false(1,nbFile);

%check all file
for idx = 1:nbFile
    [~,~,ext] = fileparts(filePath(idx));
    validExtension(idx) = ismember(ext,expectedExtension);
end

% evaluation of the outputs
if all(validExtension)
    return
else
    
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("All extensions of %s shall be consistent with the expected extension (i.e. %s\b\b).",... % \b deletes the last 2 characters
                opt.VariableName,sprintf("""%s"", ",expectedExtension)),... % requirement
    sprintf("The following files have inapropriate extension :\n%s", sprintf("\t\t- %s\n",filePath(~validExtension)))); % diagnostic
 
    throw(ME);
end
end