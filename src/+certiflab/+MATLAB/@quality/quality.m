
classdef quality < handle
    %QUALITY - evaluate the quality KPI for a MATLAB file
    %
    %   QUALITY constructor syntax:
    %       QUALITY_OBJ = QUALITY(filePath) analyse the file define by
    %       filePath. filePath is a string scalar defining the absolute or
    %       relative path of the file to assess.
    %
    %   QUALITY properties/attributes:
    %       filePath        absolute path of the assessed m-file defined as a string scalar
    %
    %       fileName        Name of the file with extension as string scalar
    %                       array in meters. N is the number of samples in the
    %                       current frame.
    %
    %   QUALITY methods/functions:
    %       Method 1        description
    %       Method 2        description
    %
    %   Examples:
    %       Line 1 of example
    %       Line 2 of example
    %       Line 3 of example
    %
    %   See also: OTHER_CLASS_NAME1,  OTHER_CLASS_NAME2
    
    %   Author : MathWorks Consulting
    %   Copyright 2021 The MathWorks, Inc.
    
    %TODO : imporve header
    
    %% PROPERTIES
    properties (SetAccess=private, GetAccess=public) % quality KPY
        filePath            (1,1) string % path of the assessed m-file
        fileName            (1,1) string % Name of the assessed m-file
        nbLine              (1,1) double % number of the line of the code
        ratioComment        (1,1) double % percentage of comment lines
        cyclomaticComplexity(1,1) double % Cyclomatic complexity of the code
        nbError             (1,1) double % number of detected error
        TODONumber          (1,1) double % number of TODO or FIXME within the code
        isAppropriateQuality(1,1) logical% boolean that explicit if the m-file respect the KPI objective (true = yes, false = no)
        
    end
    
    properties (Hidden,  SetAccess=private, GetAccess=public)
        fileContent     string          % content of the file as string array
        TODOlineinfo(:,1) string        % lines with the TODO(s)
        TODOmsg(:,1) string             % information associated to TODO line
        isCopyright(1,1) logical        % the file has a copryright ?
        nbCommentLine   (1,1) double    % number of lines of comment
        modificationDate (1,1) datetime % date of last modification
        checksum (1,1) string           % checksum MD5 of the file
        
    end
    
    properties (Constant, GetAccess=public)
        
        %SETTINGS OF THE CLASS
        maxLinesNB      = 500   % ESA constraints
        maxComplexity   = 20    % ESA constraints
        minCommentRatio = 33    % minimal percentage of comment
        maxTODONB       = 2     % two TODO are allowed
        copyrightChk    = true  % Copyrigh shall be added
        maxError        = 0     % allowed detected error
        
        %PARAMETER OF THE CLASS
        
        TODOpatern = ["%todo","%fixme";"% todo", "% fixme"] % list of the paterns detected for TODO features
        
    end
    
    %% CONSTRUCTOR / DESTRUCTOR
    
    methods
        function obj = quality(filePath)
            %QUALITY:  Class constructor
            %
            %   Inputs:
            %       filePath      absolute or relative path of the assessed
            %       m-file defined as a string scalar. tje extension of
            %       this file shall be .m and the pointed file shall exist.
            %
            %   Outputs:
            %       obj         object of class quality
            %
            %   Examples:
            %       obj = certiflab.MATLAB.quality("C:test001.m")
            %
            
            
            
            assert(nargin==1,"QUALITY:Constructor:badNargin","User shall provide a valid file path");
            
            
            % IO MANAGEMENT
            
            certiflab.check.checkStringScalar(filePath,"ErrorID","QUALITY:Constructor:filePath:BadClass","variableName","filePath");
            certiflab.check.checkFileExistence(filePath,"ErrorID","QUALITY:Constructor:filePath:NoFile");
            certiflab.check.checkExtension(filePath,".m","ErrorID","QUALITY:Constructor:filePath:BadExtension");
            
            %             % transform to absolute Path
            %             filePath        = string(which(filePath));
            
            % EXECUTION
            
            %create the filePath
            obj.filePath    = filePath;
            
            % fileName
            [~,fileName,ext]= fileparts(obj.filePath);
            obj.fileName    = string(fileName) + string(ext);
            
            % get code
            obj.getCode();
            
            %gettodo
            obj.collectTODO();
            
            % collect number of line
            obj.calculateNbLineS();
            
            % calculate complexity
            obj.calculateCyclomaticComplexity()
            
            % check error of the code
            obj.checkError();
            
            % Check for Copyright
            checkCopyRight(obj);
            
            %set last modification date
            obj.getLastModification()
            
            % get checkSum
            getCheckSum(obj)
            
            % check global quality
            checkQuality(obj);
            
            
        end
    end
    
    %% PUBLIC METHODS
    
    methods
        function disp(obj)
            %DISP overload of the disp function
            fprintf("[CERTIFLAB - CODE QUALITY]\n")
            fprintf("\t FileName        : %s\n",obj.fileName)
            fprintf("\t Nb of Lines     : %i\n",obj.nbLine)
            fprintf("\t %% of Comments   : %4.2f\n\n",obj.ratioComment)
            fprintf("\t Complexity      : %i\n\n",obj.cyclomaticComplexity)
            fprintf("\t Nb of Errors    : %i\n",obj.nbError);
            fprintf("\t Nb of TODOs     : %i\n",obj.TODONumber);
        end
        
        function qualitytable = quality2table(obj)
            
            qualitytable = table(obj.fileName,obj.filePath,obj.nbLine,obj.ratioComment,obj.cyclomaticComplexity,...
                obj.nbError,obj.TODONumber,obj.isCopyright,obj.isAppropriateQuality,{obj.TODOmsg},obj.checksum,obj.modificationDate,...
                'VariableNames',["fileName" "filePath" "nbLines", "ratioComment","cyclomaticComplexity",...
                "nbError","nbTODO","Copyright","Quality","TODOmsg","Checksum","LastModification"]);
            
            
        end
        
    end
    
    %% PRIVATE METHODS
    
    methods (Access = private)
        function getCode(obj)
            %GETCODE collect the code as a string (internal function)
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            
            fileContentTemp = matlab.internal.getCode(char(obj.filePath)); % m code as a string
            
            if (isempty(fileContentTemp))
                matlabCodeAsCellArray ={};
            else
                matlabCodeAsCellArray = strsplit(fileContentTemp, {'\r\n','\n', '\r'}, 'CollapseDelimiters', false)';
            end
            
            obj.fileContent     = string(strtrim(matlabCodeAsCellArray));% remove ident by removing space
            
        end
        
        function  collectTODO(obj)
            %COLLECTTODO - collect all the todo and fixme of the file
            % internal function
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            %search all the line with a todo
            
            if obj.fileName =="quality.m"
                %excliude quality from the collect of TODO since there are
                %many TODO to manage the grab of TODO.
                obj.TODONumber = 0;
                obj.TODOlineinfo = [];
                obj.TODOmsg = "";
                
            else
                Index = find(contains(obj.fileContent,obj.TODOpatern,'IgnoreCase',true));
                
                %count the number of TODO and fixme
                obj.TODONumber = length(Index);
                
                if not(isempty(Index))
                    
                    TODOline = obj.fileContent(Index); % remove all the space at the begining of the line
                    
                    %detect command line
                    % collectTOTO only collect the comment line with TODO not
                    % the line with a mix between command and comment.
                    
                    isCommentLine  = cellfun(@(v)v(1),TODOline)=='%';
                    
                    % remove all non comment line
                    
                    TODOline = TODOline(isCommentLine);
                    
                    % remove comment and space
                    TODOline = regexprep(TODOline,'^\s*%\s*','');
                    
                    % update of Index
                    Index = Index(isCommentLine);
                    
                    % update table
                    obj.TODOlineinfo = Index;
                    obj.TODOmsg = TODOline;
                    
                else
                    % if no TODO detected
                    obj.TODOlineinfo = [];
                    obj.TODOmsg = "";
                    
                end
            end
            
            
            
        end
        
        function calculateNbLineS(obj)
            %CALCULATENBLINES - evaluate the number of line of the fine (comment line, total line and ratio)
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            % remove line wiht nothing
            
            %calculate the real number of effecient line (comment or
            %command)
            isEmptyLine         = deblank(obj.fileContent) =="";    % with nothing
            isJustComment       = deblank(obj.fileContent) =="%";   % with just %
            cleanedFileContent  = obj.fileContent(not(isEmptyLine | isJustComment));
            
            obj.nbLine          = length(cleanedFileContent);
            
            
            %calculate the number of lines of comments
            %% nb of non empty line of comment
            isCommentLine       = startsWith(cleanedFileContent,"%",'IgnoreCase',true);
            obj.nbCommentLine   = length(obj.fileContent(isCommentLine));
            
            % calulate the ratio
            obj.ratioComment    = 100* obj.nbCommentLine/obj.nbLine;
            
            
            
        end
        
        function calculateCyclomaticComplexity(obj)
            %CYCLOMATICCOMPLEXITY finds max Cyclomatic Complexity of functions in the file
            %   CYCLOMATICCOMPLEXITY(obj) calculates the cyclomatic complexity of
            %   the function in "fileName". If the file has more than one function in
            %   it then CYCLOMATICCOMPLEXITY calculates the cyclomatic complexity of
            %   each function and reports the maximum
            %
            %   For example if you have 2 functions in the file with complexity of 7 and
            %   9 this function will report a complexity value of 9
            %   Copyright 2021 The MathWorks Inc.
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            
            s = checkcode(obj.filePath,'-cyc','-struct');
            lfunctions = {};
            lcomplexities = [];
            
            % TODO fix for R2018b
            
            p1 = 'The McCabe cyclomatic complexity of ''(\w+)'' is (\d+)\.';
            p2 = 'The McCabe cyclomatic complexity is (\d+)\.';
            
            % for R2018b
            %             p1 = 'The McCabe complexity of ''(\w+)'' is (\d+)\.';
            %             p2 = 'The McCabe complexity is (\d+)\.';
            
            for i = 1:length(s)
                m1 = regexp(s(i).message,p1,'tokens');
                m2 = regexp(s(i).message,p2,'tokens');
                if ~isempty(m1)
                    lfunctions{end+1,1} = m1{1}{1}; %#ok<AGROW>
                    lcomplexities(end+1,1) = str2double(m1{1}{2}); %#ok<AGROW>
                elseif ~isempty(m2)
                    [~,name,ext] = fileparts(obj.filePath);
                    lfunctions{end+1,1} = [name ext]; %#ok<AGROW>
                    lcomplexities(end+1,1) = str2double(m2{1}{1});         %#ok<AGROW>
                end
            end
            if isempty(lcomplexities)
                obj.cyclomaticComplexity = 0;
            else
                obj.cyclomaticComplexity = max(lcomplexities);
            end
            
        end
        
        function checkError(obj)
            %checkError verify if the COTS analyzer raised some error or
            %warning
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            % result of COTS analyzer :
            info = checkcode('-struct',obj.filePath);
            obj.nbError = length(info);
        end
        
        function checkCopyRight(obj)
            %checkCopyright verify if the Copyrigth is added to the file
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            % check if m1 or m2 are empty
            obj.isCopyright = nnz(contains(obj.fileContent,"Copyright") & contains(obj.fileContent,"The MathWorks, Inc."))>0;
            
        end
        
        function checkQuality(obj)
            %checkQuality verify if m-file respects all the KPI constraint
            
            % Author : MathWorks Consulting
            % Copyright 2021 The MathWorks, Inc.
            
            
            error_nbLine        = obj.nbLine > obj.maxLinesNB;
            error_complexity    = obj.cyclomaticComplexity > obj.maxComplexity;
            error_nbError       = obj.nbError > obj.maxError;
            error_Copyright     = obj.isCopyright == false;
            error_TODO          = obj.TODONumber > obj.maxTODONB ;
            error_Comment       = obj.ratioComment < obj.minCommentRatio;
            
            obj.isAppropriateQuality = all(not(([error_nbLine error_complexity error_nbError error_Copyright error_TODO error_Comment])));
             
        end
        
        function getLastModification(obj)
            % get the date of the lastmodification
            
            %create a file object
            fileObj = dir(obj.filePath);
            
            % set last modificaiton as a datetime
            obj.modificationDate = datetime(fileObj.datenum,'ConvertFrom','datenum');
        end
        
        function getCheckSum(obj)
            % get the checksum of the file
            
            obj.checksum = certiflab.tools.getFileChecksum(obj.filePath);
        end
            
        
    end
    
end
