function style = error()
%ERROR define style for error features

% Copyright 2021 The MathWorks, Inc.

%import Package
import mlreportgen.dom.*;

% define style :
style =  [ certiflab.report.style.content {   BackgroundColor("red"), ...
            Color('white'),...
            Bold(true)}];

end