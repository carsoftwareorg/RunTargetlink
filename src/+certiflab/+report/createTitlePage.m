
function tp = createTitlePage( title, varargin )
%CREATETITLEPAGE - creates a stanardized title page object for certiflab
%
%   SYNTAX:
%       output = CREATETITLEPAGE(input1, input2) creates a stanardized
%       page title object for certiflab
%
%   INPUTS:
%       title       string scalar that provides the title of the report
%                   page.
%
%   OUTPUTS:
%       'project',string        string describes the project Name (by
%                               default: empty)
%
%       'subtitle',string       string describes the subtitele of report (by
%                               default: empty)
%
%       'author',string         string describes the report author (by
%                               default: empty)
%
%       'logo',string           string scalar that provides the path
%                               (absolute or relative) of the logo
%
%       'image',string          string scalar that provides the path
%                               (absolute or relative) of the logo
%
%   EXAMPLES:
%       import mlreportgen.report.*
%       rpt = Report('test_report','html');
% 
%       tp = certiflab.report.createTitlePage("Software Requirements Specification",...
%           'project',"Guidance & Control System",...
%           'subtitle',"Preliminary Version");
% 
%       add(rpt,tp);
%       close(rpt);
%       rptview(rpt);
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% parameter

widthTitle = 14 ; % value in cm


%% I/O MANAGEMENT

% Management of the package
import mlreportgen.dom.*;
import mlreportgen.report.*;


%% MANAGEMENT OF VARARGIN

% default option
default_string = ""; % empty string

% Create parameters
p = inputParser;
addRequired(p,'title',@(x) certiflab.check.checkStringScalar(x,"variableName","title"));
addParameter(p,'project',default_string,@(x) certiflab.check.checkStringScalar(x,"variableName","project"));
addParameter(p,'subtitle',default_string,@(x) certiflab.check.checkStringScalar(x,"variableName","subtitle"));
addParameter(p,'author',default_string,@(x) certiflab.check.checkStringScalar(x,"variableName","author"));
addParameter(p,'logo',default_string,@(x) certiflab.check.checkStringScalar(x,"variableName","logo"));
addParameter(p,'image',default_string,@(x) certiflab.check.checkStringScalar(x,"variableName","image"));

% parse inputs
parse(p,title,varargin{:});
project         = p.Results.project;
subtitle        = p.Results.subtitle;
author          = p.Results.author;
logo            = p.Results.logo;
image           = p.Results.image;

%% CREATE THE TITLEPAGE
tp          = TitlePage();


%% CREATE TITLE BLOCK
parag = mlreportgen.dom.Paragraph();
parag.WhiteSpace='preserve';
parag.Style=[parag.Style {InnerMargin('0pt','0pt','10pt','10pt'),LineSpacing(3)}];


% manage logo
if logo~=""
    % check if image exists on the path
    certiflab.check.checkFileExistence(logo);
    
    %create image
    logoImage = Image(logo);
    
    % resize image
    px2double = @(x) str2double(x(1:end-2)); % remove px and change to double
    ImageWidth = px2double(logoImage.Width);
    ImageHeight = px2double(logoImage.Height);
    ratioSize = ImageHeight/ImageWidth;
    
    %size of the logo
    WidthExp = sprintf('%icm',widthTitle);
    heighExp = sprintf('%4.2fcm',widthTitle*ratioSize);
    logoImage.Width=WidthExp;
    logoImage.Height=heighExp;
    
    append(parag,logoImage)
    append(parag,Text(newline)); %add newline
end

if project~=""
    p_project = Text(char(project));
    p_project.Style=[p_project.Style , {Color('black'),...
        Bold(true),...
        InnerMargin("0pt", "0pt","1000pt","1000pt"),...
        FontFamily('Calibri'),FontSize('14pt')}];
    
    append(parag,p_project);
    append(parag,Text(newline));%add newline
end

p_title = Text(upper(char(title)));
p_title.Style=[p_title.Style , {Color('#0070C0'),...
    Bold(true),...
    OuterMargin("0pt", "0pt","30pt","30pt"),...
    FontFamily('Calibri'),FontSize('20pt')}];
append(parag,p_title);
append(parag,Text(newline));%add newline

if project~=""
    p_project = Text(char(subtitle));
    p_project.Style=[p_project.Style , {Color('grey'),...
        Bold(true),...
        OuterMargin("0pt", "0pt","30pt","30pt"),...
        FontFamily('Calibri'),FontSize('14pt'),Italic(true)}];
    
    append(parag,p_project);
end

% create table
t = Table({parag});
t.Style = {RowHeight('1in')};
t.Border = 'solid';
t.BorderWidth = '4px';
t.ColSep = 'solid';
t.ColSepWidth = '1';
t.RowSep = 'solid';
t.RowSepWidth = '0';
t.HAlign='center';
t.Width =sprintf('%icm',widthTitle);
t.TableEntriesHAlign = "center";

%add to title hole
tp.Title=t;

%% MANAGE IMAGE
if image~=""
    % check if image exists on the path
    certiflab.check.checkFileExistence(image);
    
    %create image
    ImObj = which(image);
    
    %add to image hole
    tp.Image=ImObj;
    
end

%% MANAGE AUTHOR
    
    %add to author hole
    tp.Author="";
    
    %% MANAGEMENT DATE
    tp.PubDate = "";
    

end

%------------- END OF CODE --------------
