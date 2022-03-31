classdef Model
    % The interface class for the TargetLink model to trigger actions for a open TL model
    
    properties (Access = private)
        CallHandler mbsd.core.message.CallHandler
        Internal mbsd.targetlink.internal.Model
    end
    
    methods

        function obj = Model(modelName)
            % Instantiates a Model.
            %
            % SYNTAX
            %   obj = Model(modelName)
            %
            % INPUT ARGUMENTS
            %   modelName
            %               String, the model name.
            obj.CallHandler = mbsd.core.message.CallHandler();

            if ~ds_isa(modelName,'slhandle')
                error('Invalid call to ''mbsd.targetlink.Model'': ''modelName'' must specify a Simulink system.');
            end
            obj.Internal = mbsd.targetlink.internal.Model(modelName);
        end


        
        function bSuccess = generateCode(obj, target)
            % Generates code for a model (code generation unit).
            %
            % This function gets the location at which to generate the code from the specification made for the code generation
            % unit via the DD ProjectFolder and DD FolderStructure objects. Here:
            % /Pool/ArtifactsLocation/FolderStructures/MBSDFolderStructure. The location of the code files is specified by
            % means of the 'ProductionCodeFiles' property and read using the tlGetArtifactLocation TargetLink API function.
            %
            % SYNTAX
            %   bSuccess = obj.generateCode(target)
            %
            % INPUT ARGUMENTS
            %   target
            %               Optional. String, the code generation target for TargetLink.
            %               See SimMode in tl_generate_code for valid values. Default = 'TL_CODE_HOST'.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the action was successful.
    
            bSuccess = obj.CallHandler.call(@() obj.Internal.generateCode(target));
            if ~bSuccess && nargout < 1
                ds_error_display();
            end
        end
        
        
        
        function bSuccess = compile(obj, target)
            % Compiles code for a model.
            %
            % This function gets the location at which to read the code from the specification made for the code generation
            % unit via the DD ProjectFolder and DD FolderStructure objects. Here:
            % /Pool/ArtifactsLocation/FolderStructures/MBSDFolderStructure. The location of the code files is specified by
            % means of the 'ProductionCodeFiles' property and read using the tlGetArtifactLocation TargetLink API function.
            %
            % SYNTAX
            %   bSuccess = obj.generateCode()
            %
            % INPUT ARGUMENTS
            %   target
            %               Optional. String, the code generation target for TargetLink.
            %               See SimMode in tl_generate_code for valid values. Default = 'TL_CODE_TARGET'.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the action was successful.
    
            bSuccess = obj.CallHandler.call(@() obj.Internal.compile(target));
            if ~bSuccess && nargout < 1
                ds_error_display();
            end
        end


        function bSuccess = setCodeCoverage(obj, tool, methodByName)
            % Sets the code coverage for the model using tlCodeCoverage.
            %
            % SYNTAX
            %   bSuccess = obj.setCodeCoverage(tool, methodByName)
            %
            % INPUT ARGUMENTS
            %   tool
            %               Optional. String, the code coverage tool.
            %               See Tool in tlCodeCoverage for valid values. Default = 'TL'.
            %   methodByName
            %               Optional. String, the code coverage method specified by name.
            %               See MethodByName in tlCodeCoverage for valid values and default.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the action was successful.

            bSuccess = obj.CallHandler.call(@() obj.Internal.setCodeCoverage(tool, methodByName));
            if ~bSuccess && nargout < 1
                ds_error_display();
            end
        end
        


        function bSuccess = exportCode(obj, codeTargetDirPath)
            % Exports generated code for the model.
            %
            % SYNTAX
            %   bSuccess = obj.exportCode(codeTargetDirPath)
            %
            % INPUT ARGUMENTS
            %   codeTargetDirPath
            %               String, the target directory path to copy the code to.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the action was successful.

            bSuccess = obj.CallHandler.call(@() obj.Internal.exportCode(codeTargetDirPath));
            if ~bSuccess && nargout < 1
                ds_error_display();
            end
        end
        


        function bSuccess = copyGeneratedFiles(obj, targetDirPath)
            % Exports generated files for the model.
            %
            % SYNTAX
            %   bSuccess = obj.copyGeneratedFiles(targetDirPath)
            %
            % INPUT ARGUMENTS
            %   targetDirPath
            %               String, the target directory path to copy to.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the action was successful.

            bSuccess = obj.CallHandler.call(@() obj.Internal.copyGeneratedFiles(targetDirPath));
            if ~bSuccess && nargout < 1
                ds_error_display();
            end
        end

    end
end

