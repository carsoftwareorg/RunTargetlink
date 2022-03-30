function style = content()
%NORMAL : generate the style called Normal for paragraph in a HTML file

% Copyright 2021 The MathWorks, Inc.

% import packages
import mlreportgen.dom.*;
import mlreportgen.report.*;

% define style : 
style = {Color('black'),FontFamily('Calibri'),FontSize('11pt'),...
        HAlign('justify'),...
        WhiteSpace('preserve'),...
        OuterMargin("0pt", "0pt","6pt","6pt")};
end