
function checkNoExistence( path2test , varargin)
%checkNoExistence - check if no folder or file exists
%
%   SYNTAX:
%       checkNoExistence(str) check if no folder or file exists
%
%   INPUTS:
%       path      path (absolute or relative) to test if no file or folder exist defined as string
%                 scalar
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkNoExistence:fileExist)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "path2test") 
%
%   OUTPUTS:
%       N/A
%
%   EXAMPLES: 
%       certiflab.check.checkNoExistence("test001.c")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
certiflab.check.checkStringScalar(path2test,"ErrorID","checkNoExistence:path2test:badClass","VariableName","path2test");


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkNoExistence:fileExists","path2test"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkNoExistence:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkNoExistence:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));

%% EXECUTION

if isfile(path2test)
    % file
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("%s shall define a non existing file or folder",opt.VariableName),... % requirement
    sprintf(" %s is an existing file", path2test)); % diagnostic
 
    throw(ME);
    
elseif isfolder(path2test)
    % folder
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("%s shall define a non existing file or folder",opt.VariableName),... % requirement
    sprintf(" %s is an existing folder", what(path2test).path)); % diagnostic
    throw(ME);
    
else
    return
end




end

%------------- END OF CODE --------------
