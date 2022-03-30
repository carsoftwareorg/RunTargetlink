
function resetFolder( folderPath )
%RESETFOLDER - reset an existing folder and create a new on with the same name
%
%   Syntax:
%       RESETFOLDER(folderPath)
%
%   Inputs:
%       folderPath      absolute or relative path of the folder as string scalar
%
%   Outputs:
%      Not applicable
%
%   Examples:
%       resetFolder('C:\temp');
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT

certiflab.check.checkStringScalar(folderPath,"ErrorID","resetFolder:folderPath:badClass","VariableName","folderPath");


%% DELETE FOLDER
try
    if isfolder(folderPath)
        [s, msg]   = rmdir(folderPath,'s');
        
        %check if it is impossible
        if s ==0 || string(msg)~=""
            
            %create exception.
            ME = certiflab.exception.createException("resetFolder:impossible2Delete",...
                sprintf("The folder %s shall be deleted",folderPath),...
                sprintf("Impossible to delete %s.\nSystem message:\n%s",folderPath,msg));
            
            %raise error
            throw(ME)
            
        end
    end
catch  exception
    
    %create exception.
    ME = certiflab.exception.createException("resetFolder:impossible2Delete",...
        sprintf("The folder %s shall be deleted",folderPath),...
        sprintf("Impossible to delete %s.\nSystem message:\n%s",folderPath,exception.message));
    
    %raise error
    throw(ME)
end


%% CREATE FOLDER

try
    [s, msg]   = mkdir(folderPath);
    %check if it is impossible
    if s ==0 || string(msg)~=""
        
        %create exception.
        ME = certiflab.exception.createException("resetFolder:impossible2Create",...
            sprintf("The folder %s shall be created",folderPath),...
            sprintf("Impossible to create %s.\nSystem message:\n%s",folderPath,msg));
        %raise error
        throw(ME)
    end
catch  exception
    
    %create exception.
    ME = certiflab.exception.createException("resetFolder:impossible2Create",...
        sprintf("The folder %s shall be created",folderPath),...
        sprintf("Impossible to create %s.\nSystem message:\n%s",folderPath,exception.message));
    
    %raise error
    throw(ME)
end


end

%------------- END OF CODE --------------
