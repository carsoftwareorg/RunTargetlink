function createFolder(folderPath, varargin)
%CREATEFOLDER create safely a folder
%
%   syntax:
%       createFolder(folderPath) create the folder folderPath and raise a
%       warning if the folder exists or an error for all the other outputs 
%
%   Inputs:
%       folderPath      absolute or relative path to the folder to create specified as a string scalar
%
%   Optional Input Arguments
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  createfolder:impossible2create)
%
%
%       "showWarning", true             logical scalar to show (true) or not
%                                       (false) the warning message. (default: true)
%                                       the error message as a string scalar (default "data2test")
%
%   Outputs:
%       N/A
%
%   examples: 
%       certiflab.tools.createFolder("test01") % no error
%       

%   Author : MathWorks Consulting
%   Copyright $year The MathWorks, Inc.


%% IO MANAGEMENT

%folderPath
certiflab.check.checkStringScalar(folderPath,"ErrorID","createFolder:folderPath:badClass","variableName","folderPath");


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","ShowWarning"],{"createfolder:impossible2create",true}, varargin{:});

% errorID
assert(isStringScalar(opt.ErrorID),"validString:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% IgnoreCase
assert(islogical(opt.ShowWarning) && isscalar(opt.ShowWarning),"createfolder:showWarning:BadClass","showWarning shall be true or false");


%% EXECUTION

% check existence of the folder
if isfolder(folderPath)
    %folder already exists
    if opt.ShowWarning
    warning("createFolder:folderExist","the folder %s already exists",folderPath);
    end
else
    [status, msg]    = mkdir(folderPath);
    
    %impossible to create a folder
    if status ==0
        ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("The folder [%s] shall be created.",folderPath),... % requirement
        sprintf("Impossible to create [message provided by the system :\%s",msg)); % diagnostic
    
        % raise error
        error(opt.ErrorID,ME.message);

    end
    
    %unexpected error
    if ~isempty(msg)
        ME = certiflab.exception.createException(opt.ErrorID,... %error ID
        sprintf("Issues occured during the creation of folder [%s].",folderPath),... % requirement
        sprintf("message provided by the system :\%s",msg)); % diagnostic

        % raise error
        error(opt.ErrorID,ME.message);
    end 
end


end