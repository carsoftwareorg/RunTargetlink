function chk = isActiveConsole(obj)
%isActiveConsole : provide the status of the console mode
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       chk     logical scalar
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.isActiveConsole();
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

chk = obj.activeConsole;

end
%------------- END OF CODE --------------