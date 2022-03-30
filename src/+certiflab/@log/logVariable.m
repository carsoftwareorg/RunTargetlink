function logVariable(obj,name,variable)
%logVariable log a variable
%
%
%   Inputs:
%       name            Name of the variable defined as string scalar
%
%       variable        variable to log
%
%   Outputs
%       N/A
%
%   Nota : the functionName within the log file is defined by the default
%   function Name defined by the methods setFunctionName
%
%   EXAMPLE
%       obj = certiflab.log();
%       a =3
%       obj.logVariable("a",a);
%


%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


% overload of the throw function
%% IO MANAGEMENT

% check variable Name
certiflab.check.checkStringScalar(name,...
    "ErrorID","logVariable:name:badClass","VariableName","name");

%% CREATE STRING FROM VARIABLE

try
    switch string(class(variable))
        case "double"
            variableStr = convertMatrix(variable,"%f");
            
        case "string"
            
            variable = certiflab.log.path2string(variable);
            variableStr = convertMatrix(variable,"%s");
            
            
        case "logical"
            variableStr = convertMatrix(variable,"%i");
            
        otherwise
            variableStr = "No display available for this class";
    end
catch ME
    variableStr = sprintf("No display available.\nSystem message:\n%s",ME.message);
end


%% LOG INFORMATION

try
    str = sprintf("\n[VARIABLE LOGING]\n")+...
        sprintf("\t- Name       : %s\n",name)+...
        sprintf("\t- Class      : %s\n",class(variable))+...
        sprintf("\t- Dimension  : %i x % i\n",size(variable,1),size(variable,2))+...
        sprintf("\t- Data :\n%s\n",variableStr);
    
catch ME
    str = sprintf("\n[VARIABLE LOGING]\n")+...
        sprintf("Impossible to log %s\nMessage:\n%s",name,ME.message);
end

obj.writeLog(certiflab.log.idInfo,str);

end

function str = convertMatrix(data2convert,dataType)

nbColumn = size(data2convert,2);

if nbColumn >0
    % format of string
    patern = char(" " + dataType);
    formatString = [repmat(patern,1,nbColumn),'\n'];
    
    % print matrix
    str = string(sprintf(formatString,data2convert'));
else
    str = "";
end

end

%------------- END OF CODE --------------