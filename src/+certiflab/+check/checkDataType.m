function checkDataType( data2test, expectedDataType,varargin )
%checkDataType - assert the data type for a constant againt expected one
%
%   SYNTAX:
%
%       checkDataType(data2test, expectedDataType) raise an error
%       if the class of data2test is different from expectedDataType.
%
%       checkDataType(data2test, expectedDataType, "ErrorID", ID) raise an error
%       if the class of data2test is different from expectedDataType with
%       the error identification ID
%
%       checkDataType(data2test, expectedDataType, "VariableName", objectName) raise an error
%       if the class of data2test is different from expectedDataType with a
%       formatted error message with the name of the name of the tested
%       object objectName
%
%   INPUTS ARGUMENTS:
%
%       data2test              variable to test against the expected class / data type
%
%       expectedDataType       Name of the expected class defined as a string scalar
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default : checkDataType:data2test:differentClass) 
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "data2test")     
%
%   OUTPUTS ARGUMENTS:
%       Not Applicable
%
%   EXAMPLES: 
%       data    = magic(5);
%       certiflab.check.checkDataType(data,"double");
%       certiflab.check.checkDataType(data,"double","ErrorID","test001:test","VariableName","test");
%
%
%   See also: isa

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% IO MANAGEMENT

% data type of expectedDataType

assert(isstring(expectedDataType),"checkDataType:expectedDataType:badClass",...
    certiflab.tools.internal.errorMSG4stringScalar("expectedDataType",expectedDataType));

%% OPTION MANAGEMENT
% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkDataType:data2test:differentClass","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkDataType:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% VariableName
assert(isStringScalar(opt.VariableName),"checkDataType:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));

%% EXECUTION

ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("The class/data type of <%s> shall be a %s object.",opt.VariableName,expectedDataType),... % requirement
    sprintf("The current class of <%s> is %s.",opt.VariableName,class(data2test))); % diagnostic

assert(string(class(data2test))== expectedDataType, opt.ErrorID , ME.message);


end

%------------- END OF CODE --------------
