function logInfo(obj,message,varargin)
%logInfo log info as an info message on the log file without console output
%
%   Inputs:
%
%       message     message text as Fomating of the outputs helds (see fprintf
%                   documentation). Message shall be a string scalar.
%
%   Outputs
%       N/A
%
%   Nota #1 : the functionName within the log file is defined by the default
%   function Name defined by the methods setFunctionName
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.logInfo("everything is OK")


%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%message
certiflab.check.checkStringScalar(message,"ErrorID","fprintf:message:badClass","VariableName","message");


%% LOG OUTPUT

% log information if enable
obj.writeLog(certiflab.log.idInfo,message,varargin{:});

end

%------------- END OF CODE --------------