
function checkExistence( path2test , varargin)
%checkExistence - check if folder or file exists
%
%   SYNTAX:
%       checkExistence(str) check if folder or file exists
%
%   INPUTS:
%       path      path (absolute or relative) to test if file or folder exists defined as string
%                 scalar
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkExistence:fileExist)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "path2test") 
%
%   OUTPUTS:
%       N/A
%
%   EXAMPLES: 
%       certiflab.check.checkExistence("test001.c")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
certiflab.check.checkStringScalar(path2test,"ErrorID","checkExistence:path2test:badClass","VariableName","path2test");


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkExistence:fileExists","path2test"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkExistence:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkExistence:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));

%% EXECUTION

if not(isfile(path2test) || isfolder(path2test))
    
    % create exception
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("%s shall exist as file or folder",opt.VariableName),... % requirement
    sprintf(" no file or folder with the path ""%s""", path2test)); % diagnostic
 
    throw(ME);    
else
    return
end




end

%------------- END OF CODE --------------
