function reset(obj)
%RESET : delete the current logFile
%
% The method reset delete the using log file.
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       N/A
%
%   Example :
%       obj = certiflab.log();
%       open(obj);

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

delete(obj.logFile);

end
%------------- END OF CODE --------------