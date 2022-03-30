function newVector = changeVector2Column(vector)
%changeVector2Column - transform a vector to a colum vector [Nx1]
%
%   INPUT ARGUMENTS
%       vector      vector to change
%
%   OUTPUT ARGUMENTS
%       newVector   vector as a colum vector (Nx1) with N the length of the
%                   vector
%
%   EXAMPLE:
%       test001 = [1 2 3]
%       newtest001 = certiflab.tools.changeVector2Colum(test001)

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MAnaGEMENT
certiflab.check.checkVector(vector,"ErrorID","changeVector2Column:vector:badDImension","VariableName","vector")


%% EXECUTION

if size(vector,1)==length(vector)
    newVector = vector;
else
    newVector = vector';
end
end
%------------- END OF CODE --------------