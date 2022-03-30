function fprintf(obj,message,varargin)
%fprintf create a console display and log it as an info message on the log file
%
% The method fprintf create a console display and log it as an info message on the log file
%
%   Inputs:
%
%       message     message text as Fomating of the outputs helds (see fprintf
%                   documentation). Message shall be a string scalar.
%
%   Outputs
%       N/A
%
%   Nota #1 : the methods will create a console outputs if the Console Mode
%   is enable
%
%   Nota #2 : the functionName within the log file is defined by the default
%   function Name defined by the methods setFunctionName
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.fprintf("everything is OK")
%       obj.fprintf"use of sprintf approach with %s\n",...
%               "the approach of sprintf")
%
%   SEE ALSO : fprintf, sprintf

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%message
certiflab.check.checkStringScalar(message,"ErrorID","fprintf:message:badClass","VariableName","message");

%% CONSOLE OUTPUT

% Print in console if enable
if obj.activeConsole
      
    %management of fprintf
    fprintf(1,message,varargin{:});
    
end

%% LOG OUTPUT

% log information if enable
obj.writeLog(certiflab.log.idInfo,message,varargin{:});

end

%------------- END OF CODE --------------