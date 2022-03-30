function copyItem(itemPath,targetPath, varargin)
%copyItem copy element (folder or file) to target path
%
%   syntax:
%       copyItem(ItemPath,targetPath, varargin) copy ItemPath(file or folder) to targetPath.
%
%   Inputs:
%       ItemPath      absolute path to the folder or file to be copied specified
%                     as a string scalar. It shall exist (folder or file)
%
%       targetPath    absolute path to the target folder of the copy as a
%                     string scalar
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
%       certiflab.tools.copyItem("c:\test01.m","d:\")
%

%   Author : MathWorks Consulting
%   Copyright $year The MathWorks, Inc.


%% IO MANAGEMENT


%folderPath
certiflab.check.checkStringScalar(itemPath,"ErrorID","copyItem:ItemPath:badClass","variableName","itemPath");


% targetPath
certiflab.check.checkStringScalar(targetPath,"ErrorID","copyItem:targetPath:badClass","variableName","targetPath");

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","ShowWarning"],{"copyItem:impossible2create",true}, varargin{:});

% errorID
assert(isStringScalar(opt.ErrorID),"copyItem:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% IgnoreCase
assert(islogical(opt.ShowWarning) && isscalar(opt.ShowWarning),"copyItem:showWarning:BadClass","showWarning shall be true or false");


%% EXECUTION

try
    
    if ~contains(itemPath,"*.*")
        %Item shall exists
        certiflab.check.checkExistence(itemPath,"ErrorID","copyItem:ItemPath:noItem","variableName","itemPath")
    else
        %folder shall exist
        certiflab.check.checkFolderExistence(fileparts(itemPath),"ErrorID","copyItem:ItemPath:noItem");
    end
    
    % target shall exist
    if ~isfolder(targetPath)
        certiflab.tools.createFolder(targetPath);
    end
    
    %copy
    [status,msg] = copyfile(itemPath, targetPath);
    
    %check copy outputs
    if msg~="" || status~=1
        error("Impossible to copy file.\nSystem message:\n%s",msg)
    end
catch exception
    
    ME = certiflab.exception.createException("copyItem:impossible2copy",...
        sprintf("Item [%s] shall be copied in the folder [%s]",itemPath,targetPath),...
        sprintf("Impossible to copy file.\nSystem message:\n%s",exception.message));
    
    %raise error
    throw(ME)
    
end

end
%------------- END OF CODE --------------