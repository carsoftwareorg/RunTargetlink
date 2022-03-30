function answer = question2user(question, varargin)
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
%       "ExpectedInformation", str      list of expected information
%                                       defined as string vector. (default: "")
%
%       "Default", str                  default value defined as string
%                                       scalar (default: "")
%
%                                             
%   OUTPUTS:
%       str     answer provided by user as string
%
%   EXAMPLES: 
%       Line 1 of example
%       Line 2 of example
%       Line 3 of example
%
%
%   See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

% question
certiflab.check.checkStringScalar(question,"ErrorID","question2user:question:badClass","VariableName","question");

% check last character
assert(endsWith(question,"?",'IgnoreCase',true),...
    "question2user:question:notAQuestion","the question shall be ended by an interrogation point (?).");


%% OPTION MANAGEMENT

opt = certiflab.tools.internal.parseVarargin(["Information","ExpectedInformation","Default"],{"","",""},varargin{:}); %#ok<CLARRSTR>

% INformation
certiflab.check.checkStringScalar(opt.Information,...
    "ErrorID","question2user:Information:badClass","VariableName","Information");

%ExpectedInformation
certiflab.check.checkStringVector(opt.ExpectedInformation,...
    "ErrorID","question2user:ExpectedInformation:badClass","VariableName","ExpectedInformation");

%Default
certiflab.check.checkStringScalar(opt.Default,...
    "ErrorID","question2user:Default:badClass","VariableName","Default");


%% EXECUTION

% go to command window
commandwindow;

% console output
fprintf("\n" + certiflab.tools.separator("-") + "\n");
fprintf("[CERTIFLAB] INPUT OF USER REQUESTED:\n\n");

%information
if opt.Information~=""
    fprintf("Information:\n");
    
    % replacement of formated information
    Information = strsplit(opt.Information,'\n');
    
    % console output
    fprintf("\t%s\n",Information)
end

% expected intpus
if opt.ExpectedInformation~=""
    fprintf("\nExpected Inputs:\n");
    
    % maange if the expected information is an explanation not a list.
    if isscalar(opt.ExpectedInformation) && contains(opt.ExpectedInformation,newline)
        % replacement of formated information
        ExpectedInformation = strsplit(opt.ExpectedInformation,'\n');
    else
        ExpectedInformation = sprintf("%s, ",opt.ExpectedInformation);
    end
    
    % console output
    fprintf("\t%s\b\b\n",ExpectedInformation)
end

%default value
if opt.Default~=""
    fprintf("\nDefault Value:\n");
    
    % replacement of formated information
    Default = strsplit(opt.Default,'\n');
    
    % console output
    fprintf("\t%s\n",Default)
end

fprintf("\n")
    
% collect information from user
answer = string (input(question + " ",'s'));

if answer ==""
    answer = opt.Default;
end
fprintf("\n" + certiflab.tools.separator("-") + "\n\n");


end

%------------- END OF CODE --------------
