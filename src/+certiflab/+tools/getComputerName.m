function computerName = getComputerName()
%GETCOMPUTERNAME - provide computer name
%
%   syntax:
%       computerName = getComputerName() provides the name of the computer
%         
%   Inputs:
%       Not Applicable
%
%   OPTIONALL INPUT ARGUMENTS
%       Not Applicable
%
%   Outputs:
%       computerName    - Name of the computer as a string scalar
%
%   examples: 
%       certiflab.tools.computerName()
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT

if nargin > 0
    error('getComputerName:noInput',' No input is accepted by the function getComputerName')
end


%% EXECUTION

[ret, computerName] = system('hostname');   
if ret ~= 0
   if ispc
      computerName = getenv('COMPUTERNAME');
   else      
      computerName = getenv('HOSTNAME');      
   end
end

computerName = string(strtrim(upper(computerName)));

% check output 
certiflab.check.checkStringScalar(computerName,"VariableName","computerName","ErrorID","getComputerName:badOutput");


end

%------------- END OF CODE --------------
