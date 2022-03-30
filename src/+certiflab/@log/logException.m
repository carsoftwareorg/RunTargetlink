function logException(obj,ME)
%logException - log Exception without raising and error
%
%   Inputs:
%       ME          MException scalar object containing the cause and location of
%                   an error.
%   Outputs
%       N/A
%
%   Nota : This fonction will not raise any error.
%
%   EXAMPLE
%       obj = certiflab.log();
%
%       try
%           surf
%       catch ME
%           obj.logException(ME)
%       end
%
%   SEE ALSO : rethrow, throw

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


% overload of the rethrow function
%% IO MANAGEMENT

% check ME
certiflab.check.checkDataType(ME,"MException","ErrorID","rethrow:ME:badClass","VariableName","ME");


%% LOG

obj.writeLog(certiflab.log.idError,ME)


%% CONSOLE OUTPUTS
if obj.activeConsole
    msg = obj.convertException2String(ME);
    fprintf("\n%s\nERROR DETECTED :\nMessage:\n%s\n%s\n\n",obj.separator("@"),msg,obj.separator("@"))
end
    
end