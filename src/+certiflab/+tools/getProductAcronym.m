function productAcronym = getProductAcronym(productName)
% getProductAcronym - provide acronym for a marketing product name
%
%   Input Arguements
%       productName         marketing name as a string scalar
%
%   Output Arguments
%       productAcronym      baseline object according to the product name
%
%   Example
%   acronym = certiflab.tools.getProductAcronym("Simulink Test");
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% PARAMETERS

qualifiedProduct = ...
            ["Simulink Test","SLTEST";...
            "Simulink Check","SLCHCK"];


%% IO MANAGEMENT
%check product Name
certiflab.check.checkStringScalar(productName,"ErrorID","getProductAcronym:badCLass","VariableName","productName")
certiflab.check.checkProduct(productName,"ErrorID","getProductAcronym:badProductName");

certiflab.check.validString(productName,qualifiedProduct(:,1),"ErrorID","getProductAcronym:ProductNotSupported","VariableName","productName");


%% EXECUTE
productAcronym = qualifiedProduct(qualifiedProduct(:,1)==productName,2);


end