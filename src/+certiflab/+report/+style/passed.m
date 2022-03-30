function style = passed()
%TABLESTYLES define style for passed features

% Copyright 2021 The MathWorks, Inc.

%import Package
import mlreportgen.dom.*;

% define style :
style =  [ certiflab.report.style.content {   BackgroundColor("#E2F0D9"), ...
            Color('green'),...
            Bold(true)}];

end