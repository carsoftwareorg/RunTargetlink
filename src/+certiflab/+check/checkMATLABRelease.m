function checkMATLABRelease()
%CHECKMATLABRELEASE - check the release of MATLAB for CERTIFLAB
%[internal function]
%   SYNTAX:
%        checkMATLABRelease() verify the current release of MATLAB and if
%        this release is not on the list of validated release for CERTIFLAB
%        an error is raised
%
%   INPUTS:
%       N/A
%
%   OUTPUTS:
%       N/A
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

% current release
currentRelease = string(version('-release'));

% validRelease
validReleases = certiflab.tools.provideValidatedReleases();

% assertion
if ~any(currentRelease==validReleases)
    %create the exception with certiflab formating
    listReleaseStr  = sprintf("%s, ",validReleases);
    ME              = certiflab.exception.createException("checkMATLABRelease:badRelease",...
        sprintf("The valid MATLAB release for CERTIFLAB are (%s\b\b). Please contact MathWorks Consulting to extend the suitable release",listReleaseStr),...
        sprintf("The current realease is %s",currentRelease));
    
    %raise error
    throw(ME);
end
        
end



%------------- END OF CODE --------------
