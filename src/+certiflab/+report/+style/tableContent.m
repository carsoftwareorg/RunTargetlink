function style = tableContent()
%TABLESTYLESHTML define style for table (except header) for HTML file

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%import package
import mlreportgen.dom.*;

%define style
style = [ certiflab.report.style.content ,...
    { ColSep('solid','black','1pt'), ...
                RowSep('solid','black','1pt'), ...
                Border('solid','black','2pt'), ...
                HAlign('center'),...
                Width("100%")}];
end

%------------- END OF CODE --------------