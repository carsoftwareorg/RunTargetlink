classdef certiflabStatus < handle
    %CERTIFLABSTATUS - One line description of what the class performs (H1 line)
    %
    %   CERTIFLABSTATUS constructor syntax:
    %       obj1 = certiflab.tools.certiflabStatus("create variable test001");
    %        
    %       log = certiflab.log();
    %       obj2 = certiflab.tools.certiflabStatus("create variable test002",log);
    %
    %   CERTIFLABSTATUS properties/attributes:
    %       No Public property
    %.
    %
    %   CERTIFLABSTATUS methods/functions:
    %       openStage   :   open a stage of activity
    %
    %       closeStage  :   finish a stage of activity and display the
    %                       result (done or failed) depending of result (true = passed,
    %                       false = failed)
    %        finish close the current feature
    %
    %   Examples:
    %       obj1 = certiflab.tools.certiflabStatus("create variable test001");
    %       obj1.openstage("describe activiity #1");
    %       obj.closestage();
    %
    %       obj1.openstage("describe activiity #2");
    %       obj1.closestage();
    %
    %       obj1.finish();
    %       Line 3 of example
    %
    
    %   Author : MathWorks Consulting
    %   Copyright 2021 The MathWorks, Inc.
    
    
    
    %% PROPERTIES
    properties (Hidden, SetAccess=private)
        featureName(1,1) string % name of the current feature (eg. function name)
        stageStatus(1,1) string {mustBeMember(stageStatus,["OPEN","CLOSED"])} = "CLOSED"
        stageName(1,1) string % name of the current stage
        t0(1,1) uint64 %begining of the feature
        log certiflab.log
        
    end
    
    properties (Constant, Hidden)
        productTitle    = "CERTIFLAB" %description of the toolbox
        sepStr = certiflab.tools.separator();
    end
    
    %% CONSTRUCTOR / DESTRUCTOR
    
    methods
        function obj = certiflabStatus(featureName,log)
            %CERTIFLABSTATUS:  Class constructor
            %
            %   Inputs:
            %       featurname      name of the feature/function as a
            %                       string scalar
            %
            %       log             certiflab log object that define the current
            %                       log object (optional, if nothing, no log management)
            %
            %   Outputs:
            %       obj         object of class certiflabStatus
            %
            %   Examples:
            %       obj1 = certiflab.tools.certiflabStatus("create variable test001");
            %
            %       log = certiflab.log();
            %       obj2 = certiflab.tools.certiflabStatus("create variable test002",log);
            %
            
            if nargin==1
                logc = certiflab.log.empty();
            else
                logc = log;
            end
            
            % set properties
            obj.t0 = tic;
            obj.featureName = featureName;
            obj.log = logc;
            
            % display title
            obj.fprintf("\n" + obj.sepStr + "\n");
            obj.fprintf("[%s] - %s:\n",obj.productTitle,obj.featureName);
            
            
        end
    end
    
    %% PUBLIC METHODS
    
    methods
        
        function openStage(obj,name)
            % openStage : open a stage of activity
            
            if obj.stageStatus == "OPEN"
                warning("a stage is already opened");
                return
            end
            
            obj.stageName = name;
            obj.stageStatus = "OPEN";
            obj.fprintf("\t - %s ...",obj.stageName)
        end
        
        function closeStage(obj,result)
            % closeStage : finish a stage of activity and display the
            % result (done or failed) depending of result (true = passed,
            % false = failed)
            
            if obj.stageStatus == "CLOSED"
                warning("no open stage");
                return
            end
            
            if nargin==1
                result=true;
            end
            
            if result
                obj.fprintf("done\n");
                obj.stageStatus = "CLOSED";
            else
                obj.fprintf("failed\n")
                obj.stageStatus = "CLOSED";
            end
        end
        
        function finish(obj)
            % finish close the current feature
            obj.fprintf("### %s finished (duration %f s)\n",obj.featureName,toc(obj.t0));
            obj.fprintf(obj.sepStr + "\n\n");
        end
        
        
    end
    
    %% PRIVATE METHODS
    
    methods (Access=private)
        
        function fprintf(obj,varargin)
            %FPRINTF - private method to overload fprintf
            
            %collect log
            logc = obj.log;
            
            if isempty(logc)
                
                fprintf(varargin{:});
            else
                logc.fprintf(varargin{:});
            end
            
        end
        
        
    end
    
    
end
