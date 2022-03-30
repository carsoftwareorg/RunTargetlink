function str = logical2string(bool)
%logical2string : transform a logical to string (true or false) for frinptf
%
%
%   INPUTS
%       bool    array of logical (true or false)
%
%   OUTPUTS
%       str     array of string with the same dimension as bool
%
%   EXAMPLE
%       A = logical([0,1,0,1,1,1;0 1 0 1 0 1]);
%       B = certiflab.log.logical2string(A)
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% PARAMETER

listLogical = ["false","true"];


%% IO MANAGEMENT

certiflab.check.checkDataType(bool,"logical","ErrorID","logical2string:bool:badClass","VariableName","bool");

% execution
str = listLogical(bool+1);

