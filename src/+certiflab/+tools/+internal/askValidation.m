function valid = askValidation(question, varargin)
%QUESTION2USER - raised a formated question to the user
%
%   SYNTAX:
%       output = QUESTION2USER(input1, input2) description of the function
%
%   INPUTS:
%       question    question asked to the user described as string scalar.
%                   THe last character shall be a interrogation point (?)
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "Information", str              Information provided before the 
%                                       question defined as string scalar.
%                                       (default: "")
%
%       "Default", str                  default value defined as string
%                                       scalar with the value "YES" or "NO" (default: "NO")
%                                             
%   OUTPUTS:
%       valid     answer provided by user as string as boolean
%
%   EXAMPLES: 
%       chk = certiflab.tools.internal.askValidation("Do you validate?")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

% question
certiflab.check.checkStringScalar(question,"ErrorID","question2user:question:badClass","VariableName","question");

% check last character
assert(endsWith(question,"?",'IgnoreCase',true),...
    "question2user:question:notAQuestion","the question shall be ended by an interrogation point (?).");


%% OPTION MANAGEMENT

opt = certiflab.tools.internal.parseVarargin(["Information","Default"],{"","NO"},varargin{:}); %#ok<CLARRSTR>

% INformation
certiflab.check.checkStringScalar(opt.Information,...
    "ErrorID","question2user:Information:badClass","VariableName","Information");

%ExpectedInformation
expectedInformation = ["YES","NO"];


%Default
certiflab.check.checkStringScalar(opt.Default,...
    "ErrorID","question2user:Default:badClass","VariableName","Default");

validDefault = validatestring(opt.Default,expectedInformation);


%% EXECUTION

% go to command window
commandwindow;

% raised question
answer = certiflab.tools.internal.question2user(question,...
    "Information",opt.Information,"ExpectedInformation",expectedInformation,"Default",validDefault);

%maange answer
switch lower(answer)
    case {"yes","y"}
        valid = true;
    case {"no","n"}
        valid = false;
    otherwise
        % create exception
        ME = certiflab.tools.internal.errorMessage("askValidation:unexpectedInput",... %ID
            "Answer of the user shall be yes, no , y or n (no case sensitivity)",... % requirement
            sprintf("Current answer ""%s"" is not supported",answer)); %diagnostic
        
        % raise error
        throw(ME);
end

%------------- END OF CODE --------------
