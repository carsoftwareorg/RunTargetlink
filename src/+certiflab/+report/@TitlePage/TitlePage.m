classdef TitlePage < mlreportgen.report.TitlePage 
    % class defined in the package reportcertif inderited from the
    % DOM.TitlePage API.
    % available template : Word and HTML
    %
    % this function can not be used outside of the function
    % evaluationCodeQuality
    %
    % No documentations are produced
    
    %   Author : MathWorks Consulting
    %   Copyright 2021 The MathWorks, Inc.
    
    
    %% PROPERTIES
    properties 
        % no custom property
    end 

    %% COnstructor
    methods 
        function obj = TitlePage(varargin) 
            % see help for report.TitlePage for more details
            obj = obj@mlreportgen.report.TitlePage(varargin{:}); 
        end 
    end 
%% Private methods
% all this methods are part from the customized reporter generator
    methods (Hidden) 
        function templatePath = getDefaultTemplatePath(~, rpt) 
            path = certiflab.report.TitlePage.getClassFolder(); 
            templatePath = ... 
                mlreportgen.report.ReportForm.getFormTemplatePath(... 
                path, rpt.Type); 
        end 

    end 
%% Tools

    methods (Static) 
        function path = getClassFolder() 
            [path] = fileparts(mfilename('fullpath')); 
        end 

        function createTemplate(templatePath, type) 
            path = certiflab.report.TitlePage.getClassFolder(); 
            mlreportgen.report.ReportForm.createFormTemplate(... 
                templatePath, type, path); 
        end 

        function customizeReporter(toClasspath) 
            mlreportgen.report.ReportForm.customizeClass(... 
                toClasspath, "reportcertif.TitlePage"); 
        end 

    end  
end
% end of file