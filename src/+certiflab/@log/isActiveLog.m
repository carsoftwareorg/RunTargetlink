function chk = isActiveLog(obj)
%isActiveLog : provide the status of the log mode
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       chk     logical scalar
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.enableLog();
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

chk = obj.activeLog;

end
%------------- END OF CODE --------------