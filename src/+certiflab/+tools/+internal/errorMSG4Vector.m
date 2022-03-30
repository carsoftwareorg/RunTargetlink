function msg = errorMSG4Vector(varName,var,expectedDim)
% internal function to standardize the error message for dimension
% comparison

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

msg = sprintf("The dimension of <%s> shall be [nx%i] or [%ixn] .\nThe current dimension of <%s> is [%ix%i].",...
    varName,expectedDim(1),expectedDim(1),varName,size(var,1),size(var,2));

end