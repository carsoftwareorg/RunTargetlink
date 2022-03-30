function style = tableHeader()
%TABLESTYLES define style for table (except header)

% Copyright 2021 The MathWorks, Inc.

%import Package
import mlreportgen.dom.*;

% define style :
style = { BackgroundColor("black"), ...
         Bold(true),Color('white'),...
         ColSep('solid','black','1pt'), ...
                RowSep('solid','black','1pt'), ...
                HAlign('center'),...
                Border('solid','black','1pt')};
end

%------------- END OF CODE --------------