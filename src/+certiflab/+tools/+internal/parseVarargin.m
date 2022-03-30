function opt = parseVarargin(parameterList,defaultval, varargin)
%parseVarargin - internal function to parse varargin features

% Author : MathWorks Consulting
% Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

assert(isvector(parameterList),"parseVaragin:parameterList:badDimension","parameterList shall be a vector")
assert(isvector(parameterList),"parseVaragin:parameterList:badClass","parameterList shall be a string vector")

assert(iscell(defaultval),"parseVaragin:defaultval:badClass","defaultval shall be a cell")
assert(isvector(defaultval),"parseVaragin:defaultval:badDimension","defaultval shall be a cell vector")


assert(length(parameterList)==length(defaultval),"parseVaragin:differentSize","the size of parameterList and defaultval shall be equal");

%% EXECUTION

% create input parser
p = inputParser;

% loop on all parameter
for idx = 1:length(parameterList)
    % create parameter
    addParameter(p,parameterList(idx),defaultval{idx});
end

% parse data
parse(p,varargin{:});

% loop on all parameter to create the opt structure
for idx = 1:length(parameterList)
    % create parameter
    opt.(parameterList(idx)) = p.Results.(parameterList(idx));
end


end