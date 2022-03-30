function checkIndexValue( data2test,varargin )
%checkVector - assert if data2test are double scalar or vector without
%decimal part
%
%   SYNTAX:
%
%       checkVector(data2test) assert if data2test are double scalar or vector without
%       decimal part
%
%   INPUTS:
%
%       data2test              variable to test
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator
%                                       with a scalar string (default :  checkIndexValue:data2test:notIndexValue)
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
%       certiflab.check.checkIndexValue([3 4.2 5])
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkIndexValue:data2test:notIndexValue","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkIndexValue:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkIndexValue:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

% assert double
certiflab.check.checkDataType(data2test,"double","ErrorID","checkIndexValue:NotADouble","VariableName",opt.VariableName)


if ~all(floor(data2test)==data2test)
    ME = certiflab.exception.createException("checkIndexValue:NotAIndex",... %error ID
        sprintf("the variable %s shall be a double without decimal part",opt.VariableName),... % requirement
        sprintf("Some element of %s have decimal part",opt.VariableName)); % diagnostic
    
    throw(ME)
end



end

%------------- END OF CODE --------------
