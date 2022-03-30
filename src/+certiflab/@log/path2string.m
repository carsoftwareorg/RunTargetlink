
function newPath = path2string( path )
%PATH2STRING - modify a path to be usable with sprintf with Windows
%
%   INPUTS:
%       path        path to modify defined as string (scalar, vector or
%                   array)
%
%   OUTPUTS:
%       newPath     new Path suitable with sprintf or fprintf defined as string
%                   scalar
%
%
%   EXAMPLES: 
%       str = certiflab.log.path2string("c:\test001")
%
%
%   See also: SPRINTF, FPRINTF

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
assert(isstring(path),"path2string:path:badClass",certiflab.tools.internal.errorMSG4stringScalar("path",path));

%% EXECUTION
newPath = strrep(path,"\","\\");


end

%------------- END OF CODE --------------
