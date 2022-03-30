function msg = errorMSG4Class(varName,var,exptectedClass)
% internal function to standardize the error message for string scalar

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

msg = sprintf("<%s> shall be a %s object .\nThe current class of <%s> is %s.",...
    varName,exptectedClass,varName,class(var));

end