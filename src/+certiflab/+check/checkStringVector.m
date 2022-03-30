function checkStringVector( data2test,varargin )
%checkStringVector - assert if the data is a string vector
%
%   SYNTAX:
%
%       CHECKSTRINGVECTOR(data2test) raises an error if data is not a string vector [1xn] or [nx1].
%
%       CHECKSTRINGVECTOR(data2test,'ErrorID', ID) raises an error if data is not a
%       string vector [1xn] or [nx1] with the error identification ID.
%
%       CHECKSTRINGVECTOR(data2test,'VariableName', objectName) raises an error if data is not a
%       string vector [1xn] or [nx1] with the name of the name of the tested
%       object objectName       
%
%   INPUTS:
%
%       data2test              variable to test
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkStringVector:data2test:NotAStringVector)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "data2test")  
%
%   OUTPUTS:
%
%       Not applicable
%
%   EXAMPLES:
%
%       certiflab.check.checkStringVector(["test" "test"])
%       certiflab.check.checkStringVector(ones(3),"ErrorID","test001:test","VariableName","test")

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],...
    {"checkStringVector:data2test:NotAStringVector","data2test"}, varargin{:}); %#ok<CLARRSTR>


% errorID
assert(isStringScalar(opt.ErrorID),"checkStringVector:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkStringVector:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

certiflab.check.checkDataType(data2test,"string","VariableName",opt.VariableName,"ErrorID",opt.ErrorID);
certiflab.check.checkVector(data2test,"VariableName",opt.VariableName,"ErrorID",opt.ErrorID);


end

%------------- END OF CODE --------------
