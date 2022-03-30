function changeLicensesStatus( productNames,newStatus )
%GETFEATURENAME - translates a toolbox name from 'ver' into
% a flexLM license name. 
%
%   Syntax:
%       changeLicensesStatus( productNames,newStatus ) change the status of
%       all product defined by productNames to the status defined by
%       newStatus
%
%   Inputs:
%       productNames        Commercial names of the toolbox defined as string
%                           vector. To grab the commercial names of available
%                           licenses, please see the ouput of the function ver
%
%       newStatus           string scalar with the two following values :
%                           "enable" or "disable"
%
%   Outputs:
%       Not applicable
%
%  Nota Bene : this function does not permit to handle Polyspace or any
%  server license.
%
%   Example
%       certiflab.tools.license.changeLicensesStatus(["UAV Toolbox","Stateflow"],"enable")
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O ASSESSMENT

%productNames
certiflab.check.checkStringVector(productNames,"ErrorID","license:changeLicensesStatus:productNames:badClass",...
    "VariableName","productNames");

%newStatus
certiflab.check.validString(newStatus,["enable","disable"],"IgnoreCase",true);

% calculate nb of product
nbProducts = length(productNames);


%% EXECUTION

%initialize logical vector

out = false(nbProducts,1);


for idx = 1:nbProducts
    
    obj = certiflab.tools.license(productNames(idx));
    
    if lower(newStatus) == "enable"
        % eneable mode
        obj.enable();
        out(idx) = obj.isAvailable();
        
    else
        %disable mode
        obj.disable();
        out(idx) = obj.isAvailable();
    end
end


% check the status
if lower(newStatus) == "enable"
        % eneable mode
        assert(all(out),"license:changeLicensesStatus:output", "all licenses are not activated")
        fprintf("[CERTIFLAB] the following products are now enable :\n%s",...
            sprintf("\t- %s\n",productNames));
        
    else
        %disable mode
        assert(all(not(out)),"license:changeLicensesStatus:output", "all licenses are not desactivated")
        fprintf("[CERTIFLAB] the following products are now disable :\n%s",...
            sprintf("\t- %s\n",productNames));
end


end