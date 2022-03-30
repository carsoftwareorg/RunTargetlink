function checkMinNargin(functionName,minNbArgin,currentNargin)
%checkMinNargin - check the minimum nb of input arguments
%[internal function]
%   SYNTAX:
%        checkMinNargin(functionName,minNbArgin,currentNargin) verify if
%        the number of input argint currentNargin is equal or greater thant
%        the minimum number of input argument defined by minNbArgin for the
%        function called functionName. If it is not validated it raises an
%        error with the ID functionName:badNargin
%
%
%   INPUTS:
%       functionName    name of the function as a string scalar
%
%       minNbArgin      minimal number of input argument as a double scalar
%
%       currentNargin   current number of input as a double scalar
%
%   OUTPUTS:
%       %TODO : add example
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%functionName
certiflab.check.checkStringScalar(functionName,"ErrorID","checkMinNargin:functionName:badClass","VariableName","functionName");

%minNbArgin
certiflab.check.checkScalar(minNbArgin,"ErrorID","checkMinNargin:minNbArgin:badDimension","VariableName","minNbArgin")
certiflab.check.checkIndexValue(minNbArgin,...
    "ErrorID","checkMinNargin:minNbArgin:badIndex","VariableName","minNbArgin");

%minNbArgin
certiflab.check.checkScalar(currentNargin,"ErrorID","checkMinNargin:currentNargin:badDimension","VariableName","currentNargin")
certiflab.check.checkIndexValue(currentNargin,...
    "ErrorID","checkMinNargin:currentNargin:badIndex","VariableName","currentNargin");

%% EXECUTION

% assertion
if currentNargin<minNbArgin
    %create the exception with certiflab formating
        ME              = certiflab.exception.createException(sprintf("%s:badNargin",functionName),...
        sprintf("The function %s shall have at least %i input argument(s)",functionName,minNbArgin),...
        sprintf("The current number of input argument(s) is %i",currentNargin));
    
    %raise error
    throw(ME);
end
        
end



%------------- END OF CODE --------------
