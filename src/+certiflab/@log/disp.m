function disp(obj)
%DISP : overloaded of disp function
%
% The method disp shows a formatted message on the MATLAB Consale that
% describes the log object.
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       N/A
%
%   EXAMPLE
%       obj = certiflab.log();
%       disp(obj)
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

fprintf("[CERTIFLAB] log information:\n")

if not(isempty(obj))
    fprintf("\tLog File               : <a href=""matlab:edit('%s')"">%s</a>\n\n",obj.logFile,obj.logFile) ;
    fprintf("\tCurrent function name  : %s\n",obj.functionName);
    fprintf("\tFunction Description   : %s\n",obj.functionDescription);
    fprintf("\tlog Mode active        : %s\n",certiflab.log.logical2string(obj.activeLog));
    fprintf("\tConsole Mode active    : %s\n",certiflab.log.logical2string(obj.activeConsole));
else
    fprintf("\tEmpty log object\n");
end

%------------- END OF CODE --------------