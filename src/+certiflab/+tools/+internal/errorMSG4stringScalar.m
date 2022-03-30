function msg = errorMSG4stringScalar(varName,var)
% internal function to standardize the error message for string scalar

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

msg = sprintf("<%s> shall be a string scalar ie. with string with dimension [1x1] .\nThe current class of <%s> is %s with a dimension of %ix%i.",...
    varName,varName,class(var),size(var,1),size(var,2));

end

%------------- END OF CODE --------------