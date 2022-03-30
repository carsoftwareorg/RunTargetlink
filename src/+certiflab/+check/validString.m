function validString( string2test,listStrings,varargin )
%validString - valid if a string is within a list of string
%
%   SYNTAX:
%
%       validString( string2test,listStrings) raises an error if string2test is not within listStrings.
%
%       validString( string2test,listStrings,"ErrorID", ID) raises an error if string2test is not within listStrings
%       with the error identification ID.
%
%       validString( string2test,listStrings,"IgnoreCase",true)) raises an error if string2test is not within listStrings
%       without taking into account the case of the list.
%
%   INPUTS:
%
%       string2test              string scalar to test
%
%       listStrings             string vector that defines the baseline
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator
%                                       with a vector of string (default :  "validString:notInList"
%
%       "IgnoreCase", boolean           logical scalar true or false to
%                                       indicate if the case is ignored  (default: false)
%
%       "VariableName", objectName      objectName provide the name of the object for
%                                       the error message as a string scalar (default "string2test")
%
%   OUTPUTS:
%
%       Not applicable
%
%   EXAMPLES:
%
%       certiflab.check.validString("test",["test01" "test02"])
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

% string2test
certiflab.check.checkStringVector(string2test,"ErrorID","validString:string2test:badClass",...
    "VariableName","string2test");

% listStrings
certiflab.check.checkStringVector(listStrings,"ErrorID","validString:listStrings:badClass",...
    "VariableName","listStrings");

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","IgnoreCase","VariableName"],{"validString:notInList",false,"string2test"}, varargin{:});

% errorID
assert(isStringScalar(opt.ErrorID),"validString:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% IgnoreCase
assert(islogical(opt.IgnoreCase) && isscalar(opt.IgnoreCase),"validString:IgnoreCase:BadClass","IgnoreCase shall be true or false");


%% EXECUTION

%change the case
if opt.IgnoreCase
    % change the case to lower
    listStrings = lower(listStrings);
    string2test = lower(string2test);
end

% assess values
if not(all(ismember(string2test,listStrings)))
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("%s shall be part of the following list:\n%s",opt.VariableName,sprintf("\t\t- %s\n",listStrings)),... % requirement
        sprintf("The following value of %s are not part of the expected list:\n%s",opt.VariableName,...
        sprintf("\t\t- %s\n",string2test(~ismember(string2test,listStrings))))); % diagnostic
    throw(ME)
    
end



end

%------------- END OF CODE --------------
