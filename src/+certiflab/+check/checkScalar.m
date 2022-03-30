function checkScalar( data2test,varargin )
%checkScalar - assert if the data is a scalar
%
%   SYNTAX:
%
%       checkScalar(data2test) raises an error if data is not a scalar [1x1].
%
%       checkScalar(data2test,'ErrorID', ID) raises an error if data is not a
%       scalar [1x1] with the error identification ID.
%
%       checkScalar(data2test,'VariableName', objectName) raises an error if data is not a
%       scalar [1x1] with the error identification ID.
%
%   INPUTS ARGUMENTS:
%
%       data2test              variable to test
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator
%                                       with a scalar string (default :  checkScalar:data2test:notAScalar)
%
%       "VariableName", objectName      objectName provide the name of the object for
%                                       the error message as a string scalar (default "data2test")
%
%   OUTPUTS ARGUMENTS:
%
%       N/A
%
%   EXAMPLES:
%
%       certiflab.check.checkScalar("abc")
%       certiflab.check.checkScalar(["abc" "cdef"],"ErrorID","test001:test","VariableName","test")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkScalar:data2test:notAScalar","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkScalar:ErrorID:badClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkScalar:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

if not(isscalar(data2test))
    % errtor message
    ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("The dimension of <%s> shall be [1x1] ie. a scalar object.",opt.VariableName),... % requirement
        sprintf("The current dimension of <%s> is %ix%i.",opt.VariableName,size(data2test,1),size(data2test,2))); % diagnostic
    
    throw(ME)
end


end

%------------- END OF CODE --------------
