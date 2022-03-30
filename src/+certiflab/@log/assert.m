function assert(obj,logicalEq,ID,message,varargin)
%assert overload the assert function to feed the log file with the appropriate message
%
% The method assert overload the assert function to feed the log file with
% the appropriate message. THis method will raised an Error if the
% condition failed and log the information
%
%   Inputs:
%       logicalEQ   Condition to assert, specified as a valid MATLAB expression.
%                   This expression must be logical or convertible to a logical.
%
%       ID          Identifier for the error, specified as a string scalar.
%                   Use the error identifier with exception handling 
%                   to better identify the source of the error or to
%                   control a selected subset of the exceptions in your
%                   program.
%
%       message     Information about assertion failure message text as
%                   Fomating of the outputs helds (see fprintf
%                   documentation).
%
%   Outputs
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.assert(false,"test001:test","error message to display")
%
%   SEE ALSO : fprintf, sprintf, setFunctionName, setConsoleMode

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

% check logicalEQ
certiflab.check.checkLogicalScalar(logicalEq,...
    "ErrorID","assert:logicalEq:badClass","VariableName","logicalEq");

%ID
certiflab.check.checkStringScalar(ID,"ErrorID","assert:ID:badClass","VariableName","ID");

%message
certiflab.check.checkStringScalar(message,"ErrorID","assert:message:badClass","VariableName","message");

%% execution

try
    % MATLAB assert
    assert(logicalEq,ID,message,varargin{:});
    
catch ME
    % manage the eror
    if obj.activeLog
        % log if log mode is enable
        obj.writeLog(certiflab.log.idError,message,varargin{:});
    end
    
    rethrow(ME);
end
    
end

%------------- END OF CODE --------------