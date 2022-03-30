classdef Section < mlreportgen.report.Section
    % SECTION : section define for the package reportcertif
    % based on the section reporter of the MATLAB REPORT GENERATOR
    % available template : word and html
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
    
    %% CONSTRUCTOR
    methods
        function obj = Section(varargin)
            %see report.section for more information
            obj = obj@mlreportgen.report.Section(varargin{:});
        end
    end
    
    % PRIVATE METHODS
    methods (Hidden)
        function templatePath = getDefaultTemplatePath(~, rpt)
            path = certiflab.report.Section.getClassFolder();
            templatePath = ...
                mlreportgen.report.ReportForm.getFormTemplatePath(...
                path, rpt.Type);
        end
        
    end
    
    %% TOOLS
    % all this methods are part from the customized reporter generator
    
    methods (Static)
        function path = getClassFolder()
            [path] = fileparts(mfilename('fullpath'));
        end
        
        function createTemplate(templatePath, type)
            path = certiflab.report.Section.getClassFolder();
            mlreportgen.report.ReportForm.createFormTemplate(...
                templatePath, type, path);
        end
        
        function customizeReporter(toClasspath)
            mlreportgen.report.ReportForm.customizeClass(...
                toClasspath, "reportcertif.Section");
        end
        
    end
end
% end of files