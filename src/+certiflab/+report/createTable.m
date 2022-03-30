
function table = createTable( data , varargin )
%CREATETABLE - create table for CertifLab Report
%
%   SYNTAX:
%       output = CREATETABLE(input1, input2) description of the function
%
%   INPUTS:
%       data      information to add to the DOM table defined as a table of N rows with M Parameters
%
%   OPTIONS:
%       'alignColumn', info         alignement of all column described as a
%                                   string vector [1xN] with N the number of 
%                                   coiumn of data.
%
%       'sizeColumn', sizetable     sizetable is a double vector that provide
%                                   the percentage of all the column. The
%                                   percentage is defined as figure between
%                                   0-100. The size of the vector shall be
%                                   consitent with the number of colum of
%                                   data and the value shall be floor
%                                   number.
%
%       'error',errorTable          errorTable contains the variable name
%                                   of the table data with array of
%                                   logical. If
%                                   errorTable.varName(idx)=true the cells
%                                   of the table uses the error style
%
%       'warning',warningTable      warningTable contains the variable name
%                                   of the table data with array of
%                                   logical. If
%                                   warningTable.varName(idx)=true the cells
%                                   of the table uses the warning style
%
%       'passed',passedTable        passedTable contains the variable name
%                                   of the table data with array of
%                                   logical. If
%                                   passedTable.varName(idx)=true the cells
%                                   of the table uses the passed style
%
%       'hyperlink',linkTable       linkTable contains the variable name
%                                   of the table data with array of
%                                   string that define the link for all cells of the concerned variable.
%                                   If the string is empty, no link will be
%                                   create.
%
%
%   NOTA BENE : if one value has two requests for modification the priority
%   order is error > warning > passed.
%
%   NOTA BENE : a column can not be formatted with "PASSED", "WARNING",
%   "ERROR" and completed with a hyperlink. Hyperlink formatting has the
%   priority.
%
%   OUTPUTS:
%       table     Description specified as a real finite N-by-3
%                   array in meters. N is the number of samples in the
%                   current frame
%   EXAMPLE:
%       % create document
%       import mlreportgen.dom.*;
%       import mlreportgen.report.*
%       d = Report('mydoc','html');
%       open(d);
%
%       % manage options
%       data        = magic(5);
%       data        = array2table(data);
%       data.text   ={["aa";"bb"];"ee";"hh";"kk";"nn"};
%       link2       = repmat("https://www.mathworks.com/",5,1);
%       link        = array2table([repmat("https://www.mathworks.com/",5,1) link2],'VariableNames',["text" "data1"]);
%       error       = array2table(repmat([true false true true false]',1,3),'VariableNames',["data1" "data3","text"]);
%       sizeColumn  = [15 15 15 15 15 25];  
%       
%       % create table
%       h= createTable( data, 'passed',error ,'warning',error,'hyperlink',link ,'sizeColumn',sizeColumn)   ;   
%       add(d,h);
%       
%       %publish 
%       close(d);
%       rptview(d.OutputPath);
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT

% Management of the package
import mlreportgen.dom.*;
import mlreportgen.report.*;


% data
assert(istable(data),"certiflab:REPORT:createTable:dataType",...
    "data shall be a table (current: %s)",class(data));

%% MANAGEMENT OF VARARGIN

% default option
default_sizeColumn = []; % empty value

default_table = array2table(zeros(0,2)); % empty table
default_ColumnAlignement = [];
% Create parameters
p = inputParser;
addRequired(p,'data',@(x) istable(x));
addParameter(p,'sizeColumn',default_sizeColumn,@(x) isnumeric(x) && isvector(x));
addParameter(p,'alignColumn',default_ColumnAlignement,@(x) isvector(x) && isstring(x))
addParameter(p,'error',default_table,@(x) istable(x));
addParameter(p,'warning',default_table,@(x) istable(x));
addParameter(p,'passed',default_table,@(x) istable(x));
addParameter(p,'hyperlink',default_table,@(x) istable(x));

% parse inputs
parse(p,data,varargin{:});
sizeColumn          = p.Results.sizeColumn;
errorTable          = p.Results.error;
warningTable        = p.Results.warning;
passedTable         = p.Results.passed;
hyperlink           = p.Results.hyperlink;
alignColumn         = p.Results.alignColumn;


% %check sizeColumn
% assert(length(sizeColumn)==size(data,2),"certiflab:REPORT:createTable:sizeColumnDim",...
%     "the length of sizeColumn shall be equal to the number of variable of data (ie. %i columns)\nCurrent number : %i",...
%     size(data,2),length(sizeColumn));

% list of header of the table
headerContent       = data.Properties.VariableNames;
listHeaderContent   = string(headerContent); %create a string array for the handling of table fields


%% define the formating for all table

% check the name of the header of options (error, warning and passed)
errorTable      = validateVariableName(errorTable, data);
warningTable    = validateVariableName(warningTable, data);
passedTable     = validateVariableName(passedTable, data);

%define information to format
info2format     = defineInfo2format(errorTable,warningTable,passedTable);

% define table of hyperlink
hyperlink       = validateHyperlink(hyperlink, data);


%% MODIFY DATA TO MEET THE EXPECTED STYLE FOR PASSED WARNING ERROR & ADD HYPERLINK

%define style for the autoformating
style.normal    = [certiflab.report.style.content   {HAlign('center')}];
style.warning   = [certiflab.report.style.warning   {HAlign('center')}];
style.error     = [certiflab.report.style.error     {HAlign('center')}];
style.passed    = [certiflab.report.style.passed    {HAlign('center')}];
style.link      = [certiflab.report.style.link      {HAlign('center')}];


for idxheader = listHeaderContent
    
    % change one column (i.e. one field of the table)
    column = changeColumnStyle(data.(idxheader), info2format.(idxheader),hyperlink.(idxheader),style);
    
    % replace field
    data.(idxheader) = column;
end

% extract data content as a cell array
dataContent     = table2cell(data);

%% CREATION OF THE TABLE
table                       = FormalTable( headerContent,dataContent);
table.Style                 = certiflab.report.style.tableContent();

table.TableEntriesStyle     = certiflab.report.style.content();
table.TableEntriesVAlign    = 'middle';
table.TableEntriesHAlign    = 'center';

table.HAlign                = 'center';
table.Header.Style          = certiflab.report.style.tableHeader();

% management of the column size
if ~isempty(sizeColumn) || ~isempty(alignColumn)
    grps    = manageCoulmStyle(data,sizeColumn,alignColumn);
    table.ColSpecGroups = grps;
end

end
%##################### ADDITIONAL FUNCTIONS #############################
function tableValid = validateVariableName(table2valid, data)
% Validate and build the entire command table based on the
% data header

% list Variable Names of Data
listBaseline = data.Properties.VariableNames;

%CHeck size
if ~isempty(table2valid)
    assert(height(table2valid)==height(data),"certiflab:report:createTable:formatSize",...
        "The size of the table that defines formating shall be the same as data (%i rows)\nCurrent : %i rows",...
        height(data),height(table2valid));
else
    % create an empty formating table
    dataFormating   = false(height(data),length(listBaseline));
    tableValid      = array2table(dataFormating,'VariableNames',listBaseline);
    return
end


% check VariableName of the input
listHeader = table2valid.Properties.VariableNames;

assert(all(ismember(listHeader,listBaseline)),"certiflab:report:createTable:headerName",...
    "Inapropriate Variable Name detected:\n%s",...
    sprintf("\t- %s\n",string(listHeader(~ismember(listHeader,listBaseline)))));


% create an empty formating table
dataFormating   = false(height(data),length(listBaseline));
tableValid      = array2table(dataFormating,'VariableNames',listBaseline);

% change the appropriate fields

for idx = string(listHeader)
    
    %check nature of the information
    assert(islogical(table2valid.(idx)),"certiflab:report:createTable:dataType",...
        "For variable %s the information shall be logical (current : %s",...
        idx, class(table2valid.(idx)));
    
    %apply change
    tableValid.(idx) = table2valid.(idx);
end



end

function tableValid = validateHyperlink(table2valid, data)
% Validate and build the entire command table based on the
% data header

% list Variable Names of Data
listBaseline = data.Properties.VariableNames;

%CHeck size
if ~isempty(table2valid)
    assert(height(table2valid)==height(data),"certiflab:report:createTable:formatSize",...
        "The size of the table that defines formating shall be the same as data (%i rows)\nCurrent : %i rows",...
        height(data),height(table2valid));
else
    % create an empty formating table
    dataFormating   = strings(height(data),length(listBaseline));
    tableValid      = array2table(dataFormating,'VariableNames',listBaseline);
    return
end


% check VariableName of the input
listHeader = table2valid.Properties.VariableNames;

assert(all(ismember(listHeader,listBaseline)),"certiflab:report:createTable:headerName",...
    "Inapropriate Variable  for hyperlink detected:\n%s",...
    sprintf("\t- %s\n",string(listHeader(~ismember(listHeader,listBaseline)))));


% create an empty formating table
dataFormating   = strings(height(data),length(listBaseline));
tableValid      = array2table(dataFormating,'VariableNames',listBaseline);

% change the appropriate fields

for idx = string(listHeader)
    
    %check nature of the information
    assert(isstring(table2valid.(idx)),"certiflab:report:createTable:dataType",...
        "For variable %s the information shall be string array (current : %s",...
        idx, class(table2valid.(idx)));
    
    %apply change
    tableValid.(idx) = table2valid.(idx);
end

end

function info2format = defineInfo2format(errorTable,warningTable,passedTable)
% define the table with the four mnemos i.e. "PASSED" "ERROR" "WARNING" & "N/A"

%list of the header of data
listHeader  = errorTable.Properties.VariableNames;

%init
info2format = array2table( repmat("N/A",size(errorTable,1),size(errorTable,2)),'VariableNames',listHeader);


for header = string(listHeader) % analyse for all variable Name
    
    for idx = 1:height(errorTable)
        
        if errorTable.(header)(idx) == true
            info2format.(header)(idx)="ERROR";
        elseif warningTable.(header)(idx) == true
            info2format.(header)(idx)="WARNING";
        elseif passedTable.(header)(idx) == true
            info2format.(header)(idx)="PASSED";
        end
        
    end
end




end

function column = changeColumnStyle(column, idx2change,hyperlink, style)
% create dom.text obj and change the style to meet the style according to
% the index idx2change


% force to have cell array instead of array of double or logical
if ~iscell(column)
    column = num2cell(column);
end

%init
val = cell(length(column),1);

% analyze the cells of the column
for idx =1:length(column)
    
    data = column{idx};
    %TODO : assert that it is a vector
    
    p =  mlreportgen.dom.Paragraph();
    p.WhiteSpace = 'preserve';
    
    for idx2data = 1: length(data)
        textObj = mlreportgen.dom.Text(data(idx2data));
        
        
        if hyperlink(idx)~=""
            
            if isnumeric(data(idx2data))
                dataInfo  = num2str(data(idx2data));
            elseif ischar(data(idx2data))
                dataInfo  = num2str(data(idx2data));
            else
                dataInfo = char(string(data(idx2data)));
            end
            
            %create external link
            textObj         = mlreportgen.dom.ExternalLink(char(hyperlink(idx)),dataInfo );
            textObj.Style   = style.link;
        elseif idx2change(idx)==  "ERROR"
            % style to modified
            textObj.Style = style.error ;
        elseif idx2change(idx)== "WARNING"
            % style to modified
            textObj.Style = style.warning ;
        elseif idx2change(idx)== "PASSED"
            % style to modified
            textObj.Style = style.passed ;
        else
            textObj.Style = style.normal ;
        end
        append(p,textObj);
        
        %add line break
        textObj = mlreportgen.dom.Text(newline);
        append(p,textObj);
        
        p.WhiteSpace = 'preserve';
        
    end
    
    val{idx} = p;
end

% outputs management
column = val;


end

function grps = manageCoulmStyle(data,sizeColumn,columnAlignment)
% create a configuration object for the management of the column size based
% on percentages

nbColumn = size(data,2);

%% IO MANAGEMENT

% check sizeColumn
if ~isempty(sizeColumn)
    certiflab.check.checkVectorSize(sizeColumn,nbColumn,...
        "ErrorID","createTable:manageCoulmStyle:sizeColumn:badClass","VariableName","sizeColumn");
    
    certiflab.check.checkIndexValue(sizeColumn,"ErrorID","createTable:manageCoulmStyle:sizeColumn:badValue","VariableName","sizeColumn");
    
    
    if not(all(sizeColumn>0 & sizeColumn<=100))
        ME = certiflab.exception.createException("createTable:manageCoulmStyle:sizeColumn:badValue",...
            "the elements of sizeColum shall be a percentage and shall be stricly greater than 0 and lower or equal to 100",...
            sprintf("The following value does not respect the value of size column: %s\b\b",sprintf("%i, ",sizeColumn(not(sizeColumn>0 & sizeColumn<=100)))));
        throw(ME)
    elseif sum(sizeColumn)~=100
        ME = certiflab.exception.createException("createTable:manageCoulmStyle:sizeColumn:badSum",...
            "The sum of all elements of sizeColumn shall be equal to 100",...
            sprintf("The sum of elements of size colum is %i.",sum(sizeColumn)));
        throw(ME)
    end  
end

%check Column Alignement

if ~isempty(columnAlignment)
    certiflab.check.checkStringVector(columnAlignment,"ErrorID","createTable:manageCoulmStyle:columnAlignment:badClass","VariableName","columnAlignment");
    
    certiflab.check.checkVectorSize(columnAlignment,nbColumn,...
        "ErrorID","createTable:manageCoulmStyle:columnAlignment:badClass","VariableName","columnAlignment");
    
    certiflab.check.validString(columnAlignment,["left","right","center","justify"],...
        "ErrorID","createTable:manageCoulmStyle:columnAlignment:badValue","VariableName","columnAlignment");  
end



%% EXECUTION

% create package of coiumn
grps(1) = mlreportgen.dom.TableColSpecGroup;
grps(1).Span = nbColumn;

%init
specs = mlreportgen.dom.TableColSpec.empty(nbColumn,0);

% create size for all column
for idx =1:nbColumn
    specs(idx) = mlreportgen.dom.TableColSpec;
    specs(idx).Span = 1;
    
    %management of column size
    if ~isempty(sizeColumn)
    specs(idx).Style =[specs(idx).Style {mlreportgen.dom.Width(sprintf('%i%%',sizeColumn(idx)))}];
    end
    
    %managemlent of column alignment
    if ~isempty(columnAlignment)
        specs(idx).Style =[specs(idx).Style {mlreportgen.dom.HAlign(char(columnAlignment(idx)))}];
    end
end

%add to group of column
grps(1).ColSpecs = specs;





end

%------------- END OF CODE --------------
