function newStruct = mergeStructure(struct1, struct2)
%mergeStructure - merge two structure with different fields
%
%   Inputs Arguments :
%       struct1     structure scalar object
%       struct2     structure scalar object
%
%   Output Argument :
%       newStruct   structure scalar object merged from struct1 and struct2
%

% TODO : add example


%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%struct1
certiflab.check.checkVector(struct1,...
    "ErrorID","mergeStructure:struct1:badDimension","VariableName","struct1");
certiflab.check.checkDataType(struct1,"struct",...
    "ErrorID","mergeStructure:struct1:badClass","VariableName","struct1");

%struct2
certiflab.check.checkVector(struct2,...
    "ErrorID","mergeStructure:struct1:badDimension","VariableName","struct1");
certiflab.check.checkDataType(struct2,"struct",...
    "ErrorID","mergeStructure:struct1:badClass","VariableName","struct1");


%check for common fields
field1 = string(fieldnames(struct1));
field2 = string(fieldnames(struct2));

commonField = intersect(field1,field2);

if ~isempty(commonField)
    ME = certiflab.exception.createException("mergeStructure:commonFields",...
        "struct 1 and struct2 shall have different fields",...
        sprintf("The following fields are common: %s\b\b",sprintf("""%s"", ",commonField)));
    %raise error
    throw(ME);
end

%check for differents sizes
if length(struct1)~=length(struct2)
    ME = certiflab.exception.createException("mergeStructure:differentSize",...
        "struct 1 and struct2 shall be vector with the same size",...
        sprintf("Size of Struct1 = %i , Size of Struct2 = %i",length(struct1),length(struct2)));
    %raise error
    throw(ME);
end


%% EXECUTION

%create merge function
mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);


newStruct = mergestructs(struct1, struct2);



end