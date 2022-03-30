function featureName = getFeatureName( tbxName )
%GETFEATURENAME - translates a toolbox name from 'ver' into
% a flexLM license name. 
% PRIVATE FUNCTION
%
%   Syntax:
%       featureName = getFeatureName(toolboxName) provides the flexLM name
%       of the toolbox defined by its name tbxName
%
%   Inputs:
%       tbxName     Commercial name of the toolbox defined as string
%                   scalar. To grab the commercial names of available
%                   licenses, please see the ouput of the function ver
%
%   Outputs:
%       featureName FlexLM name as string scalar
%
%  Nota Bene : this function does not permit to handle Polyspace or any
%  server license.
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.



%% I/O ASSESSMENT

certiflab.check.checkStringScalar(tbxName,"ErrorID","license:getFeatureName:tbxName:badClass","VariableName","tbxName");


%% APPLICATION

productidentifier = com.mathworks.product.util.ProductIdentifier.get(tbxName);  %#ok<JAPIMATHWORKS>

% If the license name is not found
if (isempty(productidentifier))
    error("license:getFeatureName:badTbxName",'The input license name (%s) is not a correct toolbox name.\n Please see the outputs of <ver> for appropriate toolbox names',tbxName)
end

% if license is Polyspace or Server (not supported by getFeaturesName)
if (contains(tbxName,'Server','IgnoreCase',true) || contains(tbxName,'Polyspace','IgnoreCase',true))
    error("license:getFeatureName:TbxnotSupported",'Management of Polyspace licenses or Server Licenses are not supported')
end

% clollect the status license
featureName  = string(productidentifier.getFlexName());



end

%------------- END OF CODE --------------
