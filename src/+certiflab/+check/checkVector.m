function checkVector( data2test,varargin )
%checkVector - assert if the data is a vector
%
%   SYNTAX:
%
%       checkVector(data) raises an error if data is not a vector [1xn] or [nx1].
%
%       checkVector(data,'ErrorID', ID) raises an error if data is not a
%       vector [1xn] or [nx1] with the error identification ID.
%
%       checkVector(data,'VariableName', objectName) raises an error if data is not a
%       vector [1xn] or [nx1] with the name of the name of the tested
%       object objectName       
%
%   INPUTS:
%
%       data2test              variable to test
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkVector:data2test:notAVector)
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
%       certiflab.check.checkVector([1 2 3])
%       certiflab.check.checkVector(ones(3),"ErrorID","test001:test","VariableName","test")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkVector:data2test:notAVector","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkVector:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkVector:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("The dimension of <%s> shall be [1xn] or [nx1] eg. a vector object with n the size of the vector.",opt.VariableName),... % requirement
    sprintf("The current dimension of <%s> is %ix%i.",opt.VariableName,size(data2test,1),size(data2test,2))); % diagnostic

assert(isvector(data2test), opt.ErrorID , ME.message);



end

%------------- END OF CODE --------------
