function checkProduct( listProduct,varargin )
%CHECKPRODUCT - check if products are available and raised appropriate error
%
%   SYNTAX:
%       output = CHECKPRODUCT(listProdcuts) check if products are available and raised appropriate error
%
%   INPUTS:
%       listProducts        list of product defined as string vector.
%                           To grab the commercial names of available
%                           licenses, please see the ouput of the function
%                           ver.
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "ErrorID", ID       ID defines the custom error identificator 
%                           with a scalar string (default :  "checkProduct:notEnable"
%
%   OUTPUTS:
%       Not applicable
%
%   EXAMPLES: 
%       certiflab.check.checkProduct("Stateflow","ErrorID","test001:test");
%


%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
certiflab.check.checkStringVector(listProduct,"ErrorID","checkProduct:listProduct:badClass","VariableName","listProduct");


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin("ErrorID",{"checkProduct:notEnable"}, varargin{:}); %#ok<STRSCALR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkProduct:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));


%% EXECUTION

%number of product to test
nbProducts = length(listProduct);

isOK = false(nbProducts,1);

% check all the producs
for idx = 1: nbProducts
    
    try 
        isOK(idx) = certiflab.tools.license( listProduct(idx)).isAvailable;
    catch
        isOK(idx) = false;
    end
end

ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("All the products shall be installed and available with appropriate licences. Please check ver outputs to have the right product Name and if theis product is available"),... % requirement
    sprintf("The following product are not available:\n%s",sprintf("\t- %s\n",listProduct(not(isOK))))); % diagnostic

assert(all(isOK), opt.ErrorID , ME.message);


end

%------------- END OF CODE --------------
