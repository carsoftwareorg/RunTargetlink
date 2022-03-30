
function str = separator(char)
%ROOT - create a string with separator (-)
%
%   SYNTAX:
%       output = ROOT(input1, input2) provides the absolute path of the root folder of CERTIFLAB package
%
%   INPUTS:
%       N/A
%
%   OUTPUTS:
%       str    - separator as a string scalar
%
%   EXAMPLES: 
%       str = certiflab.tools.separator()
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

if nargin==0
    character = "-";
else
    character = char;
end

% check input
assert(isStringScalar(character) && strlength(character)==1,"separator:badInput","input of separator shall be a string scalar whit only one character");
    

sizeline = 80;

str = sprintf("%s",repmat(character,1,sizeline)) ;



end

%------------- END OF CODE --------------
