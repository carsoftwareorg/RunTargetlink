function path = getFilename(obj)
%GETFILENAME : provide the absolute path of the log file use by the object
%
% The methods getFileName provide the absolute path of the log file use by the object
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       path : absolute path of the object as a string scalar
%
%   EXAMPLE
%       obj = certiflab.log();
%       path = getFilename(obj);
%       disp(path);
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

path = string(obj.logFile);

end
%------------- END OF CODE --------------