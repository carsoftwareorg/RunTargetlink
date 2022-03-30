function release = provideValidatedReleases()
%PROVIDEVALIDATEDRELEASES - provide the validated MATLAB releases for CERTIFLAB
%
%   SYNTAX:
%       release = provideValidatedReleases() provide the valid release as a
%       string vector called realease
%
%       provideValidatedReleases() show in the console the valid release
%
%   INPUTS:
%       N/A
%
%   OUTPUTS:
%       release     list of valid MATLAB release for CERTIFLAB as a string
%                   vector
%
%   EXAMPLES: 
%       release = provideValidatedReleases();
%       disp(release)
%       
%       provideValidatedReleases()
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% PARAMETER

validRelease = [...
    "2021a", ... % used to develop certiflab
    ]; %#ok<NBRAK>
%% EXECUTION
switch nargout
    case 0
        % no output
        fprintf("[CERTIFLAB] List of valid MATLAB releases:\n%s",...
            sprintf("\t- %s\n",validRelease));
    case 1
        % one output
        release = validRelease;
end


end

%------------- END OF CODE --------------
