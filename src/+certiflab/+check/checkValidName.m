
function checkValidName( str, varargin )
%checkValidName - check if a string is a valid Name for variable or file

%   SYNTAX:
%       CHECKVALIDNAME(str) check if a string is a valid Name for variable or file
%
%   INPUTS:
%       str      Potential variable name, specified string scalar  
%
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkValidName:data2test:invalidName)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "STR") 
%
%   OUTPUTS:
%       N/A
%
%   EXAMPLES: 
%       certiflab.check.checkValidName("test001-")
%
%
%   See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
certiflab.check.checkStringScalar(str,"ErrorID","checkValidName:str:badClass","VariableName","str");


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkValidName:data2test:invalidName","STR"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkValidName:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkValidName:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION
% evaluation of the outputs
if isvarname(str)
    return
else
    
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("%s shall be a valid variable Name as define in MATLAB documentation: A valid variable name starts with a letter, followed by letters, digits, or underscores. MATLAB® is case sensitive, so A and a are not the same variable. The maximum length of a variable name is the value that the namelengthmax command returns.",...
                opt.VariableName),... % requirement
    sprintf("The following string is not a valid variable Name:\n\t%s", str)); % diagnostic
 
    throw(ME);
end




end

%------------- END OF CODE --------------
