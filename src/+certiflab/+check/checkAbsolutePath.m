function checkAbsolutePath(path2test,varargin)
%checkAbsolutePath - check if paths are absolute for folders or files
%
%   Input Arguments
%       path2test       list of path to test described as string vector
%
%   Optionnal Input Arguments
%       "ErrorID", ID           ID of the error as a string scalar (default:
%                               checkAbsolute:NotAbsolutePath)
%
%       "VariableName",name     Name of the Variable as string scalar
%                               (default:pathList
%
%   NOTA :
%       This function does not check if the path exists or not.
%
%   Example:
%        certiflab.check.checkAbsolutePath("C:\")

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% IO MANAGEMENT

%path2test
certiflab.check.checkStringVector(path2test,"ErrorID",...
    "checkAbsolutePath:path2test:badClass","variableName","path2test")

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkAbsolute:NotAbsolutePath","pathList"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkAbsolutePath:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkAbsolutePath:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% check all paths
%init
nbPath = length(path2test);
result = false(nbPath,1);

for idx=1:nbPath
    % use Java API - non documented features
    pathJava=java.io.File(path2test(idx));
    result(idx)=pathJava.isAbsolute;
end

%% RAISE ERROR IF NECESSARY
if ~all(result)
    ME = certiflab.exception.createException(opt.ErrorID,... %errorID
        sprintf("All paths of <%s> shall be absolute paths",opt.VariableName),... %requirement
        sprintf("The following paths in <%s> are not absolute paths :\n%s",opt.VariableName,sprintf("\t\t- %s\n",path2test(~result))));
    %raise error
    throw(ME)
end

end

%------------- END OF CODE --------------



