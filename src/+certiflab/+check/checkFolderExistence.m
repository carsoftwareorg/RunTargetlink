function checkFolderExistence( folderPath,varargin )
%checkFolderExistence verify if a file or folder exist and raised error
%
%   syntax:
%       checkExistence(folderPath) raises an error if the folders defined by
%       folderPath do not exist
%
%       checkFolderExistence(folderPath,"ErrorID", ID)  raises an error if the folders defined by
%       folderPath do not exist with the error identification ID
%         
%
%   Inputs:
%       folderPath     absolute or relative path to the file specified as a string vector (Nx1) or (1xN)
%                    . N is the number of item to test.
%
%   OPTIONALL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkFolderExistence:filepath:NoExistence)
%
%   Outputs:
%       N/A
%
%   examples: 
%       certiflab.checkFolderExistence("dfgdfgdf") 
%       certiflab.check.checkFolderExistence(["C:\test001","C:\"],"ErrorID","test001:test") 
%
%
%   See also: N/A

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT

certiflab.check.checkStringVector(folderPath,"ErrorID","checkFolderExistence:folderPath:badClass","VariableName","folderPath")

%% OPTION MANAGEMENT
% parse varargin
opt = certiflab.tools.internal.parseVarargin("ErrorID",{"checkFolderExistence:folderPath:NoExistence"}, varargin{:}); %#ok<STRSCALR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkFolderExistence:ErrorID:BadCLass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));


%% EXECUTION

%check file
chkFolder     = isfolder(folderPath);

% errtor message
folderPath_str = replace(folderPath,"\","\\");

ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    "All the folders tested shall exist",... % requirement
    sprintf("The following folders do not exit :\n%s", sprintf("\t\t- %s\n",folderPath_str(~chkFolder)))); % diagnostic

%assertion
assert(all(chkFolder), opt.ErrorID , ME.message);



end

%------------- END OF CODE --------------
