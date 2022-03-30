function checkVectorSize( data2test,expectedSize,varargin )
%checkVectorSize - assert if the data is a vector
%
%   SYNTAX:
%
%       checkVectorSize(data,expectedSize) raises an error if data is not a vector [1xexpectedSize] or [expectedSizex1].
%
%   INPUTS:
%
%       data2test              variable to test
%
%       expectedSize           expected length of the vector as a double
%                              without decimale
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator
%                                       with a scalar string (default :  checkVectorSize:data2test:badVectorDimension)
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
%       certiflab.check.checkVectorSize([1 2 3],3)
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT
certiflab.check.checkScalar(expectedSize) % check if a scalar
certiflab.check.checkIndexValue(expectedSize) % check if a double without decimal part


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],...
    {"checkVectorSize:data2test:checkVectorSize:data2test:badVectorDimension","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkVectorSize:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkVectorSize:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

if not( isvector(data2test) && length(data2test)==expectedSize)
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("The dimension of <%s> shall be [1x%i] or [%ix1] vector.",opt.VariableName,expectedSize,expectedSize),... % requirement
        sprintf("The current dimension of <%s> is %ix%i.",opt.VariableName,size(data2test,1),size(data2test,2))); % diagnostic
    throw(ME)
end



end

%------------- END OF CODE --------------
