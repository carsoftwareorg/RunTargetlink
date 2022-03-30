function getFeatureVersion( obj )
%getFeatureVersion - provide the version of the toolbox pointed by the license object 
% internal function
%
%   Inputs:
%       N/A
%
%   Outputs:
%       N/A
%
%  Nota Bene : this function does not permit to handle Polyspace or any
%  server license.
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


% list of all avaiable tools
listTools = ver();

% extrat the good version

obj.version = string(listTools({listTools.Name}==obj.marketingName).Version);


end

%------------- END OF CODE --------------
