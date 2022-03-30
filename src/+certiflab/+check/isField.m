function chk =  isField(struct2analyze,fieldName)
%isField - check if a fieldname exist in a struct
%
%   INPUT ARGUMENTS
%       stuct2analyze   structure to analyzed defined as a structure
%                       object (vector or scalar strucutre. If not a structure chk = false
%
%       fieldName       name to seek in the structure defined as a string
%                       scalar
%
%   OUTPUT ARGUMENTS
%       chk             logical scalar (true : the field exists, false : the field does not exist)
%
%   EXAMPLE
%       a.b.c = 1;
%       chk =  certiflab.check.isField(a,'c')

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

% number of inputs
certiflab.check.checkMinNargin("isField",2,nargin);

%field name
certiflab.check.checkStringScalar(fieldName,"ErrorID","isField:fieldName:badClass","VariableName","fieldName")

%struct2analyze
certiflab.check.checkVector(struct2analyze,"ErrorID","isField:struct2analyze:badClass","VariableName","struct2analyze");

%% EXECUTION

if ~isstruct(struct2analyze)
    % the input is not a structure
    chk = false;
else
    
    %initialize
    chk = false;
    f = fieldnames(struct2analyze(1));
    
    for i=1:length(f)
        if string(f{i}) == strtrim(fieldName)
            chk = true;
            return;
        elseif isstruct(struct2analyze(1).(f{i}))
            chk = certiflab.check.isField(struct2analyze(1).(f{i}), fieldName);
            if chk
                return;
            end
        end
    end
end
end
    
    %------------- END OF CODE --------------
    
