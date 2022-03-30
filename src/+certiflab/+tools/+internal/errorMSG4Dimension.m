function msg = errorMSG4Dimension(varName,var,expectedDim)
% internal function to standardize the error message for dimension
% comparison

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

msg = sprintf("The dimension of <%s> shall be [%ix%i] .\nThe current dimension of <%s> is [%ix%i].",...
    varName,expectedDim(1),expectedDim(2),varName,size(var,1),size(var,2));

end