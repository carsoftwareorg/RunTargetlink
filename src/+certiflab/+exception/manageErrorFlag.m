
function manageErrorFlag( errorFlag,ME,log )
%MANAGEERRORFLAG - stop function if errorFlag is true with the Exception infos
%
%   SYNTAX:
%       output = MANAGEERRORFLAG(input1, input2) description of the function
%
%   INPUTS:
%       errorFlag   error flag (true = error) defined as logical scalar
%
%       ME          Error message as a MException scalar object 
%
%       log         certiflab.log object (optional)
%
%   OUTPUTS:
%       Not applicable
%
%   EXAMPLES: 
%       certiflab.tools.exception.manageErrorFlag(errorFlag,ME)
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

%errorFlag
certiflab.check.checkLogicalScalar(errorFlag,"ErrorID","manageErrorFlag:errorFlag:badClass","VariableName","errorFlag");

%ME
certiflab.check.checkDataType(ME,"MException","ErrorID","manageErrorFlag:ME:badClass","VariableName","ME");

%log
if nargin==2
    log = certiflab.log.empty();
end

certiflab.check.checkDataType(log,"certiflab.log","ErrorID","manageErrorFlag:log:badClass","VariableName","log");

%% EXECUTION

if isempty(log)
    %without log
    if errorFlag
        throw(ME)
    end
else
    %with log
    if errorFlag
        log.throw(ME)
    end
end
   



end

%------------- END OF CODE --------------
