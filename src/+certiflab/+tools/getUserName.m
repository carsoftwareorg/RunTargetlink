function userName = getUserName( )
%GETUSERNAME - provides the user accoumpt windows or linux
%
%   syntax:
%       userName = getUserName() provides the name of the computer
%         
%   Inputs:
%       Not Applicable
%
%   OPTIONALL INPUT ARGUMENTS
%       Not Applicable
%
%   Outputs:
%       userName    - Name of the user as a string scalar
%
%   examples: 
%       certiflab.tools.getUserName()
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT
if nargin>0
    error('getUserName:noInput',' No input is accepted by the function getUserName')
end

%% EXECUTION

if isunix()
    userName = getenv('USER');
elseif ispc() || ismac()
    userName = getenv('username');
else
    error('getUserName:unknownConfiguration',' the host environement is unknown by the function getUserName')
end

%change to string
userName = string(userName);

% check output 
certiflab.check.checkStringScalar(userName,"VariableName","userName","ErrorID","getUserName:badOutput");


end

%------------- END OF CODE --------------
