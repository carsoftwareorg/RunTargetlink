
function str = separator(paternCharacter)
%ROOT - create a string with separator (-)
%
%   SYNTAX:
%       output = ROOT(input1, input2) provides the absolute path of the root folder of CERTIFLAB package
%
%   INPUTS:
%       paternCharacter     string scalar with one character that defines
%                           the pater of the line.
%
%   OUTPUTS:
%       str    - separator as a string scalar
%
%   EXAMPLES: 
%       str = certiflab.log.separator("#")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


% check input
assert(isStringScalar(paternCharacter) && strlength(paternCharacter)==1,...
    "separator:paternCharacter:badInput","input of separator shall be a string scalar whit only one character");
    
%creeate line
str = sprintf("%s",repmat(paternCharacter,1,certiflab.log.sizeline)) ;



end

%------------- END OF CODE --------------
