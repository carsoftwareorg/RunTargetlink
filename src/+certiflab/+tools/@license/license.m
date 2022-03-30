
classdef license < handle
    %LICENSE - class to ùanage the license status of one MathWOrks Product
    %
    %   LICENSE constructor syntax:
    %       obj = certiflab.tools.license(marketingName) create a handle class
    %       to the license of the product described by marketingName
    %
    %   LICENSE properties/attributes:
    %       marketingName   marketing name of the product defined as scalar string
    %
    %       flexLMName      name used by the license manager flexLM defined as
    %                       scalar string
    %
    %       available       scalar logical that define the status of the
    %                       license (true available, false not available
    %
    %   LICENSE methods/functions:
    %       getstatus       refresh the status of the license
    %
    %       disable         disable the license associated to the object
    %
    %       enable          disable the license associated to the object
    %
    %       isAvailable     check if the license is available as logical
    %
    %       getFlexLMName   provide the flexLM name of the product as string
    %
    %
    %   See also: OTHER_CLASS_NAME1,  OTHER_CLASS_NAME2
    
    %   Author : MathWorks Consulting
    %   Copyright 2021 The MathWorks, Inc.
    
    
    
    %% PROPERTIES
    properties (SetAccess = private, GetAccess = public)
        flexLMName(1,1) string %name used by the license manager flexLM
        marketingName(1,1) string %commercial name use by the tool ver
        licenseAvailable(1,1) logical
        version(1,1) string % version of the tool provided by ver
    end
    
    %% CONSTRUCTOR / DESTRUCTOR
    
    methods
        function obj = license(marketingName)
            %LICENSE:  Class constructor
            %
            %   Inputs:
            %       marketingName      marketing name of the product defined as scalar string
            %
            %   Outputs:
            %       obj         object of class license
            %
            %   Examples:
            %       certiflab.tools.license("UAV Toolbox")
            %
            
            % IO MANAGEMENT
            certiflab.check.checkStringScalar(marketingName,"ErrorID","license:marketingName:badClass","VariableName","marketingName");
            
            % EXECUTION
            
            % set the license Name
            obj.flexLMName      = certiflab.tools.license.getFeatureName(marketingName);

            obj.marketingName   = marketingName;
            
            % get version
            obj.getFeatureVersion();
            
            % updata status
            getStatus(obj);
            
        end
    end
    
    %% PUBLIC METHODS
    
    methods (Access = public)
        
        function getStatus(obj)
            %GETSTATUS refresh the status of the license
            [s,~] = license('checkout',obj.flexLMName);
            licenseStatusCheckOut = logical(s);
            
            s = license('test',obj.flexLMName);
            licenseStatusTest = logical(s);
            
            obj.licenseAvailable = licenseStatusCheckOut || licenseStatusTest ;
            
        end
        
        function disable(obj)
            %DISABLE disable the license associated to the object
            license('checkout', obj.flexLMName,'disable')
            license('test', obj.flexLMName,'disable')
            
            %update the status of the license
            getStatus(obj)
        end
        
        function enable(obj)
            %ENABLE enable the license associated to the object
            
            % enable the license (test and checkout)
            license('checkout', obj.flexLMName,'enable')
            license('test', obj.flexLMName,'enable')
            
            %update the status
            getStatus(obj)
        end
        
        function chk = isAvailable(obj)
            %ISAVAILABLE check if the license is available
            
            %update the status
            getStatus(obj);
            
            % export the status
            chk = obj.licenseAvailable;
            
        end
        
        function str = getVersion(obj)
            %getVersion : provide the version of the tool as string scalar
            str = obj.version;
        end
        
        
        function disp(obj)
            %DISP - overload of the function disp
            
            if obj.licenseAvailable
                status = "enable";
            else
                status = "disable";
            end
            
            fprintf("[CERTIFLAB] The product ""%s"" is %s.\n",obj.marketingName,status);
        end
        
        
        function flexLMName = getFlexLMName(obj)
           %getFlexLMName provide the flexLM name of the product as string
          
           flexLMName = obj.flexLMName;
        end
        
    end
    
    methods (Access=private)
        getFeatureVersion( obj )
    end
    
    
    
    %% STATIC METHODS
    methods (Static, Access = private)
        
        featureName = getFeatureName( tbxName )
    end
    
    
    methods (Static, Access = public)
        
        changeLicensesStatus( productNames,newStatus )
        enableAllProducts()
    end
    
    
end
