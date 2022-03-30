function error(obj,ID, message,varargin)
%error overload of error -Throw error, display message and log it.
%
% The method error throws error, displays message and logs it. If Console
% mode is disable, the error will be raised in all the case.
%
%   Inputs:
%       ID        Identifier for the error, specified as a string scalar.
%
%       message     message text as Fomating of the outputs helds (see fprintf
%                   documentation). Message shall be a string scalar
%
%   Outputs
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.error("test001:test","display error message")
%
%   SEE ALSO : fprintf, sprintf, setFunctionName

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%ID
certiflab.check.checkStringScalar(ID,"ErrorID","error:ID:badClass","VariableName","ID");

%message
certiflab.check.checkStringScalar(message,"ErrorID","error:message:badClass","VariableName","message");

%% LOG ERROR
obj.writeLog(certiflab.log.idError,message,varargin{:});

%% CONSOLE OUTPUT

%add space
fprintf("\n");

%raise error
error(ID,message,varargin{:});


end

%------------- END OF CODE --------------