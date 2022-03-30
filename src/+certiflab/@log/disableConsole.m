function disableConsole(obj)
%disableConsole : disable the console mode of the log object
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.disableConsole();
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

obj.activeConsole = false;

end
%------------- END OF CODE --------------