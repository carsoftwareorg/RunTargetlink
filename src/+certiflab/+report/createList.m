function listObj = createList(list2print,varargin)
%createList - create a formatted list for certiflab report

% Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
certiflab.check.checkStringVector(list2print,"ErrorID","createList:list2print:badClass","VariableName","list2print")

%% OPTION MANAGEMENT

defaultStyle ={};
% parse varargin
opt = certiflab.tools.internal.parseVarargin(["Style"],{defaultStyle}, varargin{:}); 

%% EXECUTE

%initialisation
listRPT = cell(length(list2print),1);

%create list
for idx = 1: length(list2print)
    
    listRPT_temp = mlreportgen.dom.Text(list2print(idx));
    
    if ~isempty(opt.Style)
        listRPT_temp.Style = opt.Style;
    end
    
    %add element
    listRPT{idx} = listRPT_temp;
end

%create paragraph
listObj = mlreportgen.dom.UnorderedList(listRPT);




end