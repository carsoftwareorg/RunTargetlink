function style = link()
%LINK : generate the style called style for hyperlink

% Copyright 2021 The MathWorks, Inc.

%import package
import mlreportgen.dom.*;
import mlreportgen.report.*;

%definie link style
style = [ certiflab.report.style.content {Color('Blue'),Bold(true)}];

end