function setFunction(obj,functionName,functionDescription)
%isActiveConsole : provide the status of the console mode
%
%   INPUTS
%       N/A
%
%   OUTPUTS
%       functionName            name of the function defined as string scalar
%
%       functionDescription     description of the function defined as
%                               string scalar
%
%   EXAMPLE
%       obj = certiflab.log();
%       obj.isActiveConsole();
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%function name class
certiflab.check.checkStringScalar(functionName, "ErrorID","setFunction:functionName:badClass","VariableName","functionName");
%certiflab.check.checkValidName(functionName, "ErrorID","setFunction:functionName:badName","VariableName","functionName");

% size of the functionName inputs
if strlength(functionName)>obj.maxNbCharacterFunctionName
    %error description
    ME = certiflab.exception.createException("setFunction:functionName:badSize",...
        sprintf("the number of chararcter for function name shall be less or equal to %i",obj.maxNbCharacterFunctionName),...
        sprintf("The current functionName [%s} has %i characters.",functionName,strlength(functionName)));
    %raise error
    throw(ME)
end

%function description
certiflab.check.checkStringScalar(functionDescription, "ErrorID","setFunction:functionDescription:badClass","VariableName","functionDescription");

if contains(functionDescription,[newline string(char(13))])
    ME = certiflab.exception.createException("ErrorID","setFunction:functionDescription:badString",...
        "function Description shall be a one line description",...
        "The function description contains newline (\n) or charriot return (\r)");
    throw(ME);
end

%% SET OF FUNCTIONAME AND FUNCTION DESCRIPTION

obj.functionName        = functionName;
obj.functionDescription = functionDescription;

% empty t0

obj.t0 = uint64.empty;


end
%------------- END OF CODE --------------