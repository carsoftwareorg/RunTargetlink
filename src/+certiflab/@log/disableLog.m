function disableLog(obj)
%disableLog : disable the log mode of the log object
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.disableLog();
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

obj.activeLog = false;

end
%------------- END OF CODE --------------