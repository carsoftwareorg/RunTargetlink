function checkVectorMethod(obj2test,varargin)
%checkVectorMethod - assert if an object in a method is a vector
%
%
%   INPUTS ARGUMENTS:
%
%       obj2test              obj to test
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator
%                                       with a scalar string (default :  checkVectorMethod:obj2test:notAVector)
%
%       "MethodName", Name             Name provide the name of the method for
%                                      the error message as a string scalar (default "method")

%       "ClassName", Name              Name provide the name of the class for
%                                      the error message as a string scalar (default "customClass")
%
%   OUTPUTS ARGUMENTS:
%
%       N/A

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","ClassName","MethodName"],...
{"checkVectorMethod:obj2test:notAScalar","customClass","method"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkVectorMethod:ErrorID:badClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% ClassName
assert(isStringScalar(opt.ClassName),"checkVectorMethod:ClassName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ClassName",opt.ClassName));

% MethodName
assert(isStringScalar(opt.MethodName),"checkVectorMethod:MethodName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("MethodName",opt.MethodName));


%% EXECUTION

if not(isvector(obj2test))
    % errtor message
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("The dimension of the object for method <%s> in class <%s> shall be a vector, i.e. 1xN or Nx1.",opt.MethodName,opt.ClassName),... % requirement
        sprintf("The current dimension of the object is %ix%i.",size(obj2test,1),size(obj2test,2))); % diagnostic
    
    throw(ME)
end