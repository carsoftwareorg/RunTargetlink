function checkFileExistence( filePath,varargin )
%checkFileExistence verify if a file or folder exist and raised error
%
%   syntax:
%       checkExistence(filePath) raises an error if the files defined by
%       filePath do not exist
%
%       checkFileExistence(filePath,"ErrorID", ID)  raises an error if the files defined by
%       filePath do not exist with the error identification ID
%         
%
%   Inputs:
%       filePath     absolute or relative path to the file specified as a string vector (Nx1) or (1xN)
%                    . N is the number of item to test.
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkFileExistence:filePath:NoExistence)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "path2test") 
%
%   Outputs:
%       N/A
%
%   examples: 
%       certiflab.check.checkFileExistence("dfgdfgdf.c") 
%       certiflab.check.checkFileExistence(["test001.c","test002.c"],"ErrorID","test001:test") 
%
%
%   See also: N/A

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT

certiflab.check.checkStringVector(filePath,"ErrorID","checkFileExistence:filePath:BadClass","VariableName","filePath")

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkFileExistence:filePath:NoExistence","path2test"}, varargin{:}); %#ok<CLARRSTR> not a problem

% errorID
assert(isStringScalar(opt.ErrorID),"checkFileExistence:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% VariableName
assert(isStringScalar(opt.VariableName),"checkFileExistence:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));



%% EXECUTION

%check file
chkFile     = isfile(filePath);

% errtor message
ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("All the file in %s shall exist",opt.VariableName),... % requirement
    sprintf("The following files do not exit :\n%s", certiflab.log.path2string(sprintf("\t\t- %s\n",certiflab.log.path2string(filePath(~chkFile)))))); % diagnostic

%assertion
assert(all(chkFile), opt.ErrorID , ME.message);



end

%------------- END OF CODE --------------
