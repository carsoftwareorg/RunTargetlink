function style = warning()
%WARNING : generate the style called warning for paragraph

% Copyright 2021 The MathWorks, Inc.

% import package
import mlreportgen.dom.*;
import mlreportgen.report.*;

%define style
style = [ certiflab.report.style.content {Color('red'),Bold(true),BackgroundColor("#FBE5D6")}] ;

end