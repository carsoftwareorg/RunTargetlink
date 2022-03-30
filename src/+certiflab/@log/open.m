function open(obj)
%OPEN : overloaded of open function
%
% The method open is used to open the log file associated to the log object
% with the MATLAB Editor.
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
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

edit(obj.logFile);

end

%------------- END OF CODE --------------