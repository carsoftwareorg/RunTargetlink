function logFunctionDescription(obj,functionInfo,settingInfo,warningMSG)
%logFunctionDescription - create a description of the main certiflab
%function
%
%   INPUT ARGUMENT
%       functionInfo    string array that define the information to print with
%                       the fieldname. if empty (i.e. []) no log. The Array
%                       shall be a Nx2 array with N the number of
%                       parameters to log.
%
%       settingInfo     string array that define the settings to print with
%                       the fieldname. if empty (i.e. []) no log. The Array
%                       shall be a Nx2 array with N the number of
%                       parameters to log.
%
%       warningMSG      string scalar that define the warning msessage to print with
%                       if empty (i.e. []) no log.
%
%   OUTPUT ARGUMENTS
%       N\A
%
%   EXAMPLE
%
%       info = ["name","test01";"version","1.0"]
%       log = certiflab.log()
%       log.logFunctionDescription(info,[],[]);

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%%IO MANAGEMENT
certiflab.check.checkMinNargin("logFunctionDescription",4,nargin)

%% TITLE

obj.fprintf("\n\n%s\n\n",sprintf("%s\n",obj.title()));


%% FUNCTION DESCRIPTION
if ~(isempty(functionInfo))
    
    %input shall be a string array
    certiflab.check.checkDataType(functionInfo,"string","ErrorID","logFunctionDescription:functionInfo:badClass","VariableName","functionInfo");
    
    if size(functionInfo,2)~=2
        %bad number of columns
        ME = certiflab.exception.createException("logFunctionDescription:functionInfo:badSize",...
            "The size of functionInfo shall be Nx2 array of string with N the number of elements to log",...
            sprintf("the size of functionInfo is [%i x %i]",size(functionInfo,1),size(functionInfo,2)));
        % raise error
        throw(ME)
    end
    
    % pad functionInfo first colum
    newfunctionInfo = pad(functionInfo(:,1));
    
    %loop for all fields
    for idx = 1:size(functionInfo,1)
        obj.fprintf("%s\t: %s\n",upper(newfunctionInfo(idx,1)),functionInfo(idx,2))
    end
    
    %line separation
    obj.fprintf("\n%s\n\n",certiflab.log.separator("@"));
end


%% SETTINGS DESCRIPTION
if ~(isempty(settingInfo))
    
    %input shall be a string array
    certiflab.check.checkDataType(settingInfo,"string","ErrorID","logFunctionDescription:settingInfo:badClass","VariableName","settingInfo");
    
    if size(settingInfo,2)~=2
        %bad number of columns
        ME = certiflab.exception.createException("logFunctionDescription:settingInfo:badSize",...
            "The size of settingInfo shall be Nx2 array of string with N the number of elements to log",...
            sprintf("the size of settingInfo is [%i x %i]",size(settingInfo,1),size(settingInfo,2)));
        % raise error
        throw(ME)
    end
    
    % pad functionInfo first colum
    newsettingInfo = pad(settingInfo(:,1));
    
    obj.fprintf("[EXECUTION SETTINGS]:\n");
    
    %loop for all fields
    for idx = 1:size(settingInfo,1)
        obj.fprintf("\t> %s\t: %s\n",upper(newsettingInfo(idx,1)),settingInfo(idx,2))
    end
    
    %line separation
    obj.fprintf("\n%s\n\n",certiflab.log.separator("@"));
end

%% WARNING MESSAGE
if ~(isempty(warningMSG))
    
    %input shall be a struct
    certiflab.check.checkStringScalar(warningMSG,"ErrorID","logFunctionDescription:warningMSG:badClass","VariableName","warningMSG");
    
    %add title
    obj.fprintf("[WARNING]:\n%s\n",warningMSG);
    
    %line separation
    obj.fprintf("\n%s\n\n",certiflab.log.separator("@"));
end

%------------end of file -------------

end