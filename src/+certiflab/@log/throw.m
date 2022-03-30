function throw(obj,ME)
%throw overload the throw function to feed the log file and raise error
%
% The method throw overload the throw function to feed the log file with
% the appropriate message. THis method throws previously caught
% exception.
%
%   Inputs:
%       ME          MException scalar object containing the cause and location of
%                   an error.
%   Outputs
%       N/A
%
%   Nota : the functionName within the log file is defined by the default
%   function Name defined by the methods setFunctionName
%
%   EXAMPLE
%       obj = certiflab.log();
%
%       try
%           surf
%       catch ME
%           obj.throw(ME)
%       end
%
%   SEE ALSO : throw

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


% overload of the throw function
%% IO MANAGEMENT

% check ME
certiflab.check.checkDataType(ME,"MException","ErrorID","rethrow:ME:badClass","VariableName","ME");


%% LOG EXCEPTION
obj.writeLog(certiflab.log.idError,ME)

%add space
fprintf(1,"\n");

% raise error
throw(ME)

end

%------------- END OF CODE --------------