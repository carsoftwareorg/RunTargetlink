function enableAllProducts()
%enableAllProducts - force to enable the license of all available products

%
%   Syntax:
%       enableAllProducts() force to enable the license of all available products
%
%   Inputs:
%       Not Applicable
%
%   Outputs:
%       Not applicable
%
%  Nota Bene : this function does not permit to handle Polyspace or any
%  server license.
%
%   Example
%       certiflab.tools.license.enableAllProducts()
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% EXECUTION

% list of product

listProducts =  struct2table(ver());
listProducts =  string(listProducts.Name);

nbProducts = length(listProducts);

%initialize logical vector

out = false(nbProducts,1);


for idx = 1:nbProducts
    
    try
        % create license object
        obj = certiflab.tools.license(listProducts(idx));
        obj.enable();
        out(idx) = obj.isAvailable();
    catch ME
        % management of the custom toolbox
        if (strcmp(ME.identifier,'license:getFeatureName:badTbxName'))
            fprintf ("\tProduct %s is not on the scope of the license management\n",listProducts(idx))
            out(idx) = true ;
        else
            rethrow(ME)
        end
    end
    
end


% check the status

assert(all(out),"license:enableAllProducts:output", "all licenses are not activated")
fprintf("[CERTIFLAB] All the products are now activated\n");




end