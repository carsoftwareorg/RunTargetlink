classdef Model
    % The TargetLink model to trigger actions for a open TL model
    
    properties
        Name string
    end

    properties (Constant)
        CODE_HOST = 'TL_CODE_HOST'
        CODE_TARGET = 'TL_CODE_TARGET'
        CC_TL = 'TL'
        CC_CTC = 'CTC'
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
            obj.Name = modelName;
        end


        
        function generateCode(obj, target)
            % Generates code for a model.
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

            if nargin < 2
                target = obj.CODE_HOST;
            end

            includeSubItems = 'on'; % TODO: optimization, define rules where subitems can be reused
            tlSystemsCell = get_param(get_tlsubsystems(obj.Name), 'Name');
            ddCgusCell = {}; % TODO: decide where to get dd cgus

            args = {'Model', obj.Name, ...
                    'TlSubsystems', tlSystemsCell, ...
                    'IncludeSubItems', includeSubItems, ...
                    'SimMode', target};
            if ~isempty(ddCgusCell)
                args{'DDCodeGenerationUnits'} = ddCgusCell; % TODO: decide where to get dd cgus
            end
    
            % Generate code.
            tl_generate_code(args{:});
        end
        
        
        
        function compile(obj, target)
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

            tlSystemsCell = get_param(get_tlsubsystems(obj.Name), 'Name');
            ddCgusCell = {}; % TODO: decide where to get dd cgus

            args = {'Model', obj.Name, ...
                    'TlSubsystems', tlSystemsCell, ...
                    'SimMode', target};
            if ~isempty(ddCgusCell)
                args{'DDCodeGenerationUnits'} = ddCgusCell; % TODO: decide where to get dd cgus
            end
    
            switch(target)
                case obj.CODE_HOST
                    tl_compile_host(args{:});
                case obj.CODE_TARGET
                    tl_compile_target(args{:});
                otherwise
                    error('MBSD:Model:compile:invalidTarget', ...
                        'Unsupported option selected: target = %s', target);
            end
        end



        function integrateIncrementalCGUs(obj, includedSubItemsCell)
            % Integrates the incremental code generation unit and their existing artifacts in the
            % integration model's environment.
            %
            % To be able to use existing artifacts of the incremental code generation units, their location must be specified in
            % the Data Dictionary of the integration model by means of DD ProjectFolder and FolderStructure objects.
            % No files need to be copied.
            %
            % In the active model, the same DD FolderStructure object is used for all code generation units. The object is
            % provided as an include DD.
            % Additionally, the metadata (saved DD Subsystem object) of the incremental code generation units is loaded to your
            % main Data Dictionary. If the code generation unit metadata is not loaded explicitly, it is loaded on demand during
            % code generation for surrounding code generation units.
            %
            % SYNTAX
            %   obj.integrateIncrementalCGUs(includedSubItemsCell)
            %
            % INPUT ARGUMENTS
            %   includedSubItemsCell
            %               Cell of strings, incremental code generation units below the current one, specified as names of the
            %               code generation unit.
            
            for m = 1:numel(includedSubItemsCell)
                cguName = includedSubItemsCell{m};
                
                % Load the incremental CGU metadata. Ignore errors and
                % instead register them for later interpretation
                [~, msgStruct] = tlCodeGenerationMetadata('Load','CodeGenerationUnits', cguName,...
                    'Overwrite','on',...
                    'IncludeSubitems','off',...
                    'Model',obj.Name);
                if ~isempty(msgStruct)
                    ds_error_register(msgStruct);
                end
                
            end
        end
        


        function setCodeCoverage(obj, tool, methodByName)
            % Sets the code coverage for the model using tlCodeCoverage.
            %
            % SYNTAX
            %   obj.setCodeCoverage(tool, methodByName)
            %
            % INPUT ARGUMENTS
            %   tool
            %               Optional. String, the code coverage tool.
            %               See Tool in tlCodeCoverage for valid values. Default = 'TL'.
            %   methodByName
            %               Optional. String, the code coverage method specified by name.
            %               See MethodByName in tlCodeCoverage for valid values and default.

            if nargin < 2
                tool = obj.CC_TL;
            end

            if nargin < 3
                methodByName = char.empty;
            end

            args = {'Set', obj.Name, ...
                    'Tool', tool, ...
                    'ApplyForAll', true ... 'make' all CGUs with CODE_COVERAGE=ON
                    };
            if ~isempty(methodByName)
                args{'MethodByName'} = methodByName;
            end
    
            % Set code coverage mode.
            tlCodeCoverage(args{:});
        end
        


        function exportCode(obj, codeTargetDirPath)
            % Exports generated code for the model.
            %
            % SYNTAX
            %   obj.exportCode(codeTargetDirPath)
            %
            % INPUT ARGUMENTS
            %   codeTargetDirPath
            %               String, the target directory path to copy the code to.

            ignoreSubItems = 'off'; % TODO: optimization, define rules where subitems can be reused / must not be exported again
            tlSystemsCell = get_param(get_tlsubsystems(obj.Name), 'Name');

            args = {'Model', obj.Name, ...
                    'Subsystems', tlSystemsCell, ...
                    'DestDir', codeTargetDirPath, ...
                    'CopySystemFiles', 'on', ...
                    'CopyDocumentation', 'on', ...
                    'CopyTools', 'on', ...
                    'IgnoreSubItems', ignoreSubItems, ...
                    'Verbose', 'off' ...
                    };
            tl_export_files(args{:});
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

            genDirPath = char.empty;
            tlSystemsCell = get_param(get_tlsubsystems(obj.Name), 'Name');
            [artifactLocation, ~, ~, ~, msgStruct] = tlGetArtifactLocation( ...
                'CodeGenerationUnit', tlSystemsCell{1}, ...
                'ArtifactType', 'SimulationFrameCodeFiles');
            if ~isempty(msgStruct)
                ds_error_register(msgStruct);
            end
            if ~isempty(artifactLocation)
                genDirPath = fileparts(artifactLocation);
            end
            if isempty(genDirPath)
                oProject = matlab.project.currentProject();
                if ~isempty(oProject)
                    genDirPath = fullfile(oProject.ProjectPath, '_gen');
                end
            end
            if isempty(genDirPath)
                error('Could not derive genDirPath')
            end
            copyfile(genDirPath, targetDirPath, 'f');
            
            bSuccess = true;
        end
    end
end

