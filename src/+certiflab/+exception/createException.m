
function ME = createException( ID, requirementMSG, diagnosticMSG )
%ERRORMESSAGE -  function to standardize Exception object
%
%   INPUT ARGUMENTS
%       ID              Identifier for the error, specified as a string scalar
%
%       requirementMSG  Requirements message specified as a string scalar
%
%       diagnosticMSG   Diagnostic message specified as a string scalar
%
%   OUTPUT ARGUMENTS
%       ME              Constructed MException object
%
%   EXAMPLE
%       ME = certiflab.exception.createException("test001:test","requirement details", "diagnostic details")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%ID
assert(isStringScalar(ID),"createException:ID:baClass","ID shall be a string scalar");

%requirementMSG
assert(isStringScalar(requirementMSG),"createException:requirementMSG:baClass","requirementMSG shall be a string scalar");

%requirementMSG
assert(isStringScalar(diagnosticMSG),"createException:diagnosticMSG:baClass","diagnosticMSG shall be a string scalar");

%%CREATE EXCEPTION
% create messsage
msg = sprintf("\n[%s]\n\nRequirements:\n\t%s\n\nDiagnostic:\n\t%s",...
    ID,certiflab.log.path2string(requirementMSG),certiflab.log.path2string(diagnosticMSG));

% create the exception 
ME = MException(ID,msg);

end

%------------- END OF CODE --------------
