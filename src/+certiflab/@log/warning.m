function warning(obj,ID, message, varargin)
%warning - Display and log warning message
%
% The method warning displays and logs warning message.If Console
% mode is disable, the warning message will not be showed in the console.
%
%   Inputs:
%       ID          Identifier for the warning, specified as a string scalar.
%
%       message     message text as Fomating of the outputs helds (see fprintf
%                   documentation)
%
%   Outputs
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.warning("test001:test","display warning message")
%
%   SEE ALSO : fprintf, sprintf, setFunctionName

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%ID
certiflab.check.checkStringScalar(ID,"ErrorID","warning:ID:badClass","VariableName","ID");

%message
certiflab.check.checkStringScalar(message,"ErrorID","warning:message:badClass","VariableName","message");

%% LOG WARNING
obj.writeLog(certiflab.log.idWarning,message,varargin{:});

%% CONSOLE OUTPUT




if obj.activeConsole
    
    
    % display of warning message
    warning(ID,message,varargin{:})
    

end

end

%------------- END OF CODE --------------