classdef log < handle
    %LOG -Advanced logging tool for MATLAB
    %   This class provides configurable logging capabilites for MATLAB
    %   applications.
    %
    %   Logger provides for singleton logger instances given a
    %   unique name of the application. This means that you can get an
    %   instance of the same logger from multiple places in code without
    %   needing to pass around the object handle!
    %
    %   LOG constructor syntax:
    %       obj = certiflab.log() - create a log object with a file stored
    %       in the temporary file as log.txt
    %
    %       obj = certiflab.log("LogFile",filePath) - create a log object with a
    %       log file stored on path filePath that define log file path
    %       (absolute or relative) with the appropriate extension (".txt" ,
    %       ".dat", ".data", ".log") described as a string scalar
    %
    %       obj = certiflab.log("FunctionName",name) - create a log object with a file stored
    %       in the temporary file as log.txt. THe name of the function used
    %       on the log file is name, defined as a string scalar
    %
    %   LOG properties/attributes:
    %       NO PUBLIC PROPERTIES
    %
    %   LOGGER methods/functions:
    %       disp - overloaded of disp function
    %       open - overloaded of open function
    %       RESET - delete the current logFile
    %
    %       getFileName     - provide the absolute path of the log file use by the object
    %       isActiveLog     - provide the status of the log mode
    %       isActiveConsole - provide the status of the console mode
    %
    %       setLogFile      - Change the location of the text log file.
    %       enableConsole   - enable Console Mode
    %       enableLog       - enable Log Mode
    %       disableConsole  - disable Console Mode
    %       disableLog      - disable Log Mode
    %       setFunction     - Set the function name and associated description of the log object
    %
    %       warning - overload of warning- Display and log warning message
    %       error - overload of error - Throw error, display message and log it.
    %
    %       fprintf - create a console display and log it as an info message on the log %file
    %       assert - overload of the assert function for log
    %       rethrow- overload of the rethrow function and rethrow previously caught exception.
    %       logException - display exception and add error log
    %       logVariable - log a variable
    %       logInfo - log info as an info message on the log file without console output
    %
    %
    %       
    %
    %   Examples:
    %       log = certiflab.log()
    %
    
    
    %   Author : MathWorks Consulting
    %   Copyright 2021 The MathWorks, Inc.
    
    %% PROPERTIES
    
    properties (SetAccess = private, GetAccess = private)
        logFile         (1,1) string % path of the log file
        functionName    (1,1) string % name of the function
        functionDescription     (1,1) string % description of the function
        activeLog       (1,1) logical   = true  % status of the log mode (i.e. creation/authoring of a log file) [true(default) = enable / false = disable]
        activeConsole   (1,1) logical   = true  % status of the console output mode (i.e. show information within the console) [true(default) = enable / false = disable]
        currentTask     (1,1) string    = ""    % description of the current task as string scalar without newline
        activeTask      (1,1) logical   = false % define if the task is active (true) or non active (false)
        t0              uint64        % start for the function functionName
    end
    
    properties (Constant , Access = protected)
        % default properties for the initialisation of the log (no access
        % possible
        defaultLogFileName          = "log.txt";
        defaultFunctionName         = "functionName";
        defaultFunctionDescription  = "";
        defaultPath                 = string(tempdir);
        maxNbCharacterFunctionName  = 30;
        listLogExtension            = [".txt",".dat",".log",".data"]
        idInfo                      = "       "
        idError                     = "ERROR  "
        idWarning                   = "WARNING"
        statusMsg                   = ["failed","done"]
        defaultStatusMsg            = true
        sepStr                      = 1
        sizeline                    = 90;
    end
    
    
    %% CONSTRUCTOR / DESTRUCTOR
    
    methods
        function obj = log(varargin)
            %LOGGER:  Class constructor
            %
            %   Inputs:
            %       N/A
            %
            %   Optional Inputs
            %       "LogFile", fileName     fileName (string scalar) is the
            %                               absolute path to the log file. the
            %                               extension shall be ".txt",
            %                               ".dat", ".data" or ".log".
            %                               (default :log.txt in the temp
            %                               folder of the host computer)
            %
            %       "FunctionName", fctName Name of the function to display
            %                               on the log file defined as
            %                               string scalar (default :
            %                               "function")
            %       "FunctionDescription",str   Description of function displayed within title
            %                                   of function console output defined as a string
            %                                   scalar without newline or chariot
            %                                   return (default:"")
            %
            %   Outputs:
            %       obj - object of class logger
            %
            %   Examples:
            %       log = certiflab.log();
            %       log2 = mlog.logger("LogFile","C:\temp\log.txt");
            %
            
            
            %OPTION MANAGEMENT
            % list of options
            OptionList      = ["LogFile","FunctionName","FunctionDescription"];
            
            % list of default value
            logFile_default = fullfile(obj.defaultPath,obj.defaultLogFileName);
            defaultValue    = {logFile_default,obj.defaultFunctionName,obj.defaultFunctionDescription};
            
            % create the option structure
            opt = certiflab.tools.internal.parseVarargin(OptionList,defaultValue,varargin{:});
            
            
            % NB : control of LogFile, functionName and functionDescription
            % is done by setLogFile & setFunction
            
            % add function name and function description
            obj.setFunction(opt.FunctionName,opt.FunctionDescription);
            
            % new file
            obj.setLogFile(opt.LogFile);
            
        end %function
        
    end
    
    %% PUBLIC METHODS :
    methods
        
        % OVERLOAD
        disp(obj) % overload of disp function
        open(obj) % overload of open function
        reset(obj)% delete the current logFile
        
        % GET INFORMATION
        path = getFilename(obj)         % provide the absolute path of the log object
        chk = isActiveLog(obj)          % provide the status of the log mode
        chk = isActiveConsole(obj)      % provide the status of the console mode
        
        % SETTINGS MANAGEMENT
        setLogFile(obj,logFile)                             % Change the location of the text log file.
        setFunction(obj,functionName,functionDescription)   % Set the function name and associated description of the log object
        
        enableConsole(obj)        %enable Console Mode
        enableLog(obj)            %enable Log Mode
        disableConsole(obj)       %disable Console Mode
        disableLog(obj)           %disable Log Mode
        
        
        %% MANAGE MESSAGE (warning, error, info)
        
        
        warning(obj, funcName, message, varargin)   % overload of warning- Display and log warning message
        error(obj, funcName, message,varargin)      % overload of error - Throw error, display message and log it.
        
        fprintf(obj,message,varargin) %create a console display and log it as an info message on the log %file
        
        assert(obj,logicalEq,ID,msg,varargin) %overload of the assert function for log
        
        rethrow(obj,ME) % overload of the rethrow function and rethrow previously caught exception.
        throw(obj,ME)   % overload of the throw function.
        
        logException(obj,ME) %log Exception without raising an error
        
        logVariable(obj,name,variable) % log a variable
        
        logInfo(obj,message,varargin) %log info as an info message on the log file without console output
        
        logFunctionDescription(obj,functionInfo,settingInfo,warningMSG)
        
        
        %% CONSOLE OUTPUTS FOR THE STATUS
        function openTask(obj,taskName)
            % openStage : open a stage of activity
            %
            %   INPUT ARGUMENTS
            %       taskName    Name of the tasks as string scalar
            %
            %   OUTPUT ARGUMENTS
            %       N/A
            %
            %   EXAMPLE
            %       obj = certiflab.log()
            %       obj.openTask("task001");
            %
            
            % check if function is started
            if isempty(obj.t0)
                warning("The execution of the function under loging is not started please use method startFunctionExecution");
                return
            end
            
            
            if obj.activeTask == true
                % A task is already opened
                warning("A task is already opened. Please close it with method closeTask");
            else
                % no task opened
                certiflab.check.checkStringScalar(taskName, "ErrorID","openTask:taskName:badClass","VariableName","functionDescription");
                
                if contains(taskName,[newline string(char(13))])
                    ME = certiflab.exception.createException("ErrorID","openTask:taskName:badString",...
                        "function Description shall be a one line description",...
                        "The taskName contains newline (\n) or charriot return (\r)");
                    throw(ME);
                end
                obj.currentTask = taskName;
                obj.activeTask = true;
                
                % print information
                obj.fprintf("\t> %s ...\n",obj.currentTask)
                            
            end
        end
        
        function closeTask(obj,result)
            % closeStage : finish a stage of activity and display the
            % result (done or failed) depending of result (true = passed,
            % false = failed)
            %
            %   INPUTS ARGUMENTS
            %       result  (optional) logical scalar (true = done, false =
            %               failed) - default: true
            %
            %   OUTPUTS ARGUMENTS
            %       N/A
            %
            
            if nargin==1
                    % default value is done
                    result=certiflab.log.defaultStatusMsg;
            end
            
            
            %IO MANAGEMENT
            
            %result
            certiflab.check.checkLogicalScalar(result,"ErrorID","closeTask:result:badClass","VariableName","result");
            
            % EXECUTION
            
            if obj.activeTask == false
                % No task opened
                warning("No opened tasks. Please use method openTask");
                return
            else
                obj.fprintf("\t> %s ... %s\n",obj.currentTask,obj.statusMsg(result+1))
                            
                % change status
                obj.activeTask = false;
            end
        end
        
        function finish(obj)
            % finish close the current feature
            %
            %   INPUTS ARGUMENTS
            %       N/A
            %
            %   OUTPUTS ARGUMENTS
            %       N/A
            %
            if isempty(obj.t0)
                warning("The execution of the function under loging is not started please use certiflab.log.startFunctionExecution");
            else
                
                obj.fprintf("[CERTIFLAB] - %s finished (duration %f s)\n",obj.functionName,toc(obj.t0));
                obj.fprintf(certiflab.log.separator("-")+ "\n\n");
                obj.t0 = uint64.empty();
            end
        end
        
        function startFunctionExecution(obj)
            % Display the first information in the console about the
            % execution of functionName
            %
            %   INPUTS ARGUMENTS
            %       N/A
            %
            %   OUTPUTS ARGUMENTS
            %       N/A
            %
            
            % set properties
            obj.t0 = tic;
            
            % display title
            obj.fprintf("\n" + certiflab.log.separator("-") + "\n");
            obj.fprintf("[CERTIFLAB] - %s: %s\n",obj.functionName,obj.functionDescription);
              
        end
        
        
        
    end
    
    methods (Static)
        %static function usable externally
        str = logical2string(bool)          %convert boolean to a string (true false)
        newPath = path2string( path )       %change the path to a string with \\
        str = separator(paternCharacter)    % create a separator line
    end
    
    %% PRIVATE METHODS
    
    methods (Access = private)
        function writeLog(obj,level,message,varargin)
            %WRITELOG - internal function to the class, that writes the
            %information on the logFile
            
            %if log mode is disable, the writelog function is stop
            if obj.activeLog == false
                return
            end
            
            % header (first part of the line)
            header  = certiflab.log.buildHeader(level,obj.functionName);
            
            % message as string array (depending of the format)
            msg     = certiflab.log.buildMessage(message,varargin{:});
            
            for idxMsg = msg
                
                msg2print = header + idxMsg;
                
                % protect the writing
                try
                    fid = fopen(obj.logFile,'a');
                    fprintf(fid,"%s\n" ...
                        ,msg2print);
                    fclose(fid);
                catch ME
                    % transform error to warning
                    warning(ME.identifier,"Impossible to log :\n%s",ME.message);
                    
                    %close file
                    fclose(fid);
                end
            end
            
        end
    end
    
    methods (Static, Access = protected)
        
        TXT = title()
        
        function msgText = convertException2String(mExceptionObj)
            % Convert MException with stack trace to message text
            
            % modify message
            message = strsplit(string(mExceptionObj.message),'\n','CollapseDelimiters',false);
            message = sprintf("\t\t%s\n",message);
            
            
            % Include the stack
            if ~isempty(mExceptionObj.stack)
                msgInputs = [{mExceptionObj.stack.name};{mExceptionObj.stack.line}];
                stackText = sprintf("\t\t> %s (line %d)\n"',msgInputs{:});
            else
                stackText = sprintf("\t\t> no stack information available\n");
            end
            
            % final message
            msgText = sprintf("\nEXCEPTION DETAILS\n\t- identifier : %s\n\t- System message:\n\t\t%s\n\t- Stack information:\n%s",...
                string(mExceptionObj.identifier),...
                message,...
                stackText);
            
        end %function
        
        function header = buildHeader(level,funcName)
            % build the header of message
            
            % level and function :
            textFormat  = sprintf(' %%%is   %%s\t',certiflab.log.maxNbCharacterFunctionName);
            msg         = sprintf(textFormat,funcName,level);
            
            %final header
            header = sprintf("%s - %s" ...
                , datestr(now,'yyyy-mm-dd HH:MM:SS,FFF') ...
                , msg);
        end
        
        function msg    = buildMessage(message,varargin)
            % build message as a string array
            
            % create message as formated string
            if isa(message,'MException')
                %case : exception as input
                msg = certiflab.log.convertException2String(message);
                
                %split in string array
                msg = strsplit(msg,'\n','CollapseDelimiters',false);
                
            elseif nargin >= 1 && isStringScalar(string(message))
                msgText = sprintf(message,varargin{:});
                
                %remove last element
                msg = strsplit(msgText,'\n','CollapseDelimiters',false);
                
                % suppress last element of message if empty
                if msg(end)==""
                    msg(end) =[];
                end
                
            else
                error("log:inputConfig","input configuration is not permitted")
            end

        end
        
    end %methods
end
