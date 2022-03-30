function generateReport(qualityMetrics,folderPath,opt)
%GENERATEREPORT create report for the function evaluateCodeQuality
% private function
%
% this function can not be used outside of the function
% evaluationCodeQuality
%
% No documentations are produced

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

% check license of MATLAB Report Generator
certiflab.check.checkProduct("MATLAB Report Generator")


%% INITIALISATION
% constants (herited from the object):
maxLinesNB      = certiflab.MATLAB.quality.maxLinesNB;
maxError      = certiflab.MATLAB.quality.maxError;
minCommentRatio = certiflab.MATLAB.quality.minCommentRatio;
maxComplexity   = certiflab.MATLAB.quality.maxComplexity;
maxTODO         = certiflab.MATLAB.quality.maxTODONB;
copyrightChk    = certiflab.MATLAB.quality.copyrightChk;

%default Names
reportTitle ="MATLAB Code Quality";

% Import packages
import mlreportgen.dom.*;
import mlreportgen.report.*;

% define the rpt containers
% no need to add the extension to the path, MATLAB report generator will do
% it. 
switch opt.Extension
    case ".pdf"
        rpt         = Report(fullfile(opt.Folder2save,opt.ReportName),"pdf");
    case ".html"
        rpt         = Report(fullfile(opt.Folder2save,opt.ReportName),"html-file");
    case ".htmx"
        % generate a htmx file, i.e. a zipped html file
        rpt         = Report(fullfile(opt.Folder2save,opt.ReportName),"html");   
end

%% ADD TITLEPAGE
% use the certiflab feature to create a pagetitle
      titlepage = certiflab.report.createTitlePage(reportTitle,...
          'project',"Evaluation of the KPI for MATLAB codes",...
          "subtitle",folderPath,...
          'author',certiflab.tools.getUserName());
      add(rpt,titlepage);



%% ADD TABLE OF CONTENTS
toc = TableOfContents;
toc.Title = Text('Table of Contents');
add(rpt,toc);


%% Add SECTION : Introduction of the analysis
% introduction
sec1        = certiflab.report.Section();
sec1.Title  = 'Introduction';
intro       = ['This report provides the current status of the m file in the analyzed directies'...
    'with quality metrics (eg. number of line, complexity, ...) and the status of the development '...
    'with report of TODO and fixme.'];
para        = Paragraph(intro);
para.Style = certiflab.report.style.content();
add(sec1,para);

% legend table
intro               = 'The following table provides the recommanded objectives for the different KPI:';
para                = Paragraph(intro);
para.Style          = certiflab.report.style.content();
add(sec1,para);

% definition of the content
headerContent = {'Metrics','Recommended'};
dataTable = {   'Max line number',sprintf('%i lines',maxLinesNB);...
    'Nb of Errors',sprintf('%i error(s)',maxError);...
    'Min Comment Ratio',sprintf('%i %%',minCommentRatio);...
    'Max Complexity',sprintf('%i ',maxComplexity);...
    'Nb of TODO',sprintf('%i TODO(s)',maxTODO);...
    'Need Copyright',char(string(copyrightChk))};

% creation of the table
table                       = FormalTable( headerContent,dataTable);

%formating the table
table.TableEntriesStyle     = certiflab.report.style.content;
table.Style = [ certiflab.report.style.content() ,...
    { ColSep('solid','black','1pt'), ...
    RowSep('solid','black','1pt'), ...
    Border('solid','black','1pt'), ...
    HAlign('center')}];
table.Header.Style          = certiflab.report.style.tableHeader();

% add table to the section
add(sec1,table)

% add section to the report
add(rpt,sec1)

%% Add SECTION : Result for quality

% extract from quality Metrics the showed fields
qualityTable = qualityMetrics(:,["fileName", "filePath" ,"nbLines", "ratioComment","cyclomaticComplexity","nbError","nbTODO","Copyright","Quality"]);

% introduction
sec1        = certiflab.report.Section();
sec1.Title  = 'Results';
intro       = sprintf("The following table provides the results of the Quality KPI for MATLAB Code for the folder %s.",folderPath);
para        = Paragraph(intro);
para.Style = certiflab.report.style.content();
add(sec1,para);

% create link for file
% only the first column has links.
link = "matlab:edit " + fullfile(qualityTable.filePath);
link = array2table(link,'VariableNames',"fileName");

%create error
error_nbLine        = qualityTable.nbLines > maxLinesNB;
error_complexity    = qualityTable.cyclomaticComplexity > maxComplexity;
error_nbError       = qualityTable.nbError > maxError;
error_Copyright     = qualityTable.Copyright == false;
error_TODO          = qualityTable.nbTODO > maxTODO ;
error_Comment       = qualityTable.ratioComment < minCommentRatio;
error_Quality       = qualityTable.Quality == false;

% create a table with the same header as the quality metrics
errorlog        = array2table([error_nbLine,error_complexity,error_nbError,error_Copyright,error_TODO,error_Comment,error_Quality ],...
    'VariableNames',["nbLines","cyclomaticComplexity","nbError","Copyright","nbTODO","ratioComment","Quality"]);

% reformat ratioComment
qualityTable.ratioComment = arrayfun(@(v) sprintf("%2.0f %%",v),qualityTable.ratioComment);

% reformat filePath to relative path
qualityTable.filePath = arrayfun(@(v) erase(v,folderPath+filesep),fileparts(qualityTable.filePath));

% create the table
h= certiflab.report.createTable( qualityTable,'hyperlink',link,'error',errorlog);

% add table to the section
add(sec1,h);

% add section to the report
add(rpt,sec1)

%% Add SECTION : TODO

% extract from quality Metrics the showed fields
TODOTable = qualityMetrics(qualityMetrics.nbTODO>0,["fileName" ,"filePath","nbTODO","TODOmsg"]);

% introduction
sec1        = certiflab.report.Section();
sec1.Title  = 'List of TODO';
intro       = sprintf("The following table provides all the TODO/FIXME detected for the folder %s.",folderPath);
para        = Paragraph(intro);
para.Style = certiflab.report.style.content();
add(sec1,para);

% create link for file
% only the first column has links.
link = "matlab:edit " +fullfile(TODOTable.filePath);
link = array2table(link,'VariableNames',"fileName");

% reformat filePath to relative path
TODOTable.filePath = arrayfun(@(v) erase(v,folderPath+filesep),fileparts(TODOTable.filePath));

% create the table
h= certiflab.report.createTable( TODOTable,'hyperlink',link);

% add table to the section
add(sec1,h);

% add section to the report
add(rpt,sec1)

%% Add SECTION : FILE STATUS

% extract from quality Metrics the showed fields
statusTable = qualityMetrics(:,["fileName" ,"filePath","LastModification","Checksum"]);

% introduction
sec1        = certiflab.report.Section();
sec1.Title  = 'M-file Status';
intro       = sprintf("The following table provides the status of all m-file within the folder %s.",folderPath);
para        = Paragraph(intro);
para.Style = certiflab.report.style.content();
add(sec1,para);

% create link for file
% only the first column has links.
link = "matlab:edit " +fullfile(statusTable.filePath);
link = array2table(link,'VariableNames',"fileName");

% reformat filePath to relative path
statusTable.filePath = arrayfun(@(v) erase(v,folderPath+filesep),fileparts(statusTable.filePath));

%reformat last modification date
statusTable.LastModification = string(statusTable.LastModification);

% create the table
h= certiflab.report.createTable( statusTable,'hyperlink',link);

% add table to the section
add(sec1,h);

% add section to the report
add(rpt,sec1)

%% Generate Report
close(rpt);

% open report
rptview(rpt.OutputPath)
end
% end of code