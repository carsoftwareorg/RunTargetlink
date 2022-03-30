function  relativePath = getRelativePath( absolutePath, referencePath )
%RELATIVEPATH  returns the relative path from an actual path to the target path.
%   Both arguments must be strings with absolute paths.
%   The actual path is optional, if omitted the current dir is used instead.
%   In case the volume drive letters don't match, an absolute path will be returned.
%   If a relative path is returned, it always starts with '.\' or '..\'
%
%   Syntax:
%      rel_path = RELATIVEPATH( target_path, actual_path )
%
%   Input Argument:
%      absolutePath       - Path(s) which is targetted described as string
%                           vector. Absolute paths shall be contained in
%                           the reference path (ie. ".." is not permited)
%
%      referencePath      - Start for relative path described as string
%                           scalar
%
%   Examples:
%       relativePath = getRelativePath( "C:\local\data\matlab" , "C:\local" )
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% IO MANAGEMENT

%number of input
certiflab.check.checkMinNargin("getRelativePath",2,nargin)

%absolutePath
certiflab.check.checkStringVector(absolutePath,...
    "ErrorID","getRelativePath:absolutePath:badClass","VariableName","absolutePath");

% referencePath
certiflab.check.checkStringScalar(referencePath,...
    "ErrorID","getRelativePath:absolutePath:badClass","VariableName","absolutePath");

%% EXECUTE

% add filesep to referencePath path
referencePath = addFileSep(referencePath);

% add filesep to referencePath path
absolutePath = arrayfun(@(x) addFileSep(x), absolutePath);

% check if the absolute path are contained in the reference path
idxValidAbsolutePath = contains(absolutePath,referencePath);

%detect if some path are not in the reference path
if ~all(idxValidAbsolutePath)
    warning("all the absolute path are contains in the reference path")
end

relativePath = strrep(absolutePath(idxValidAbsolutePath),referencePath,"");

end
%############## ADDITIONAL FUNCTION #################################
function newPath = addFileSep(oldPath)
%addFileSep - add if necessary a file sep at the end of a path and remove
%the extension if necessary

newPath = oldPath;

[~,~,extension] = fileparts(newPath);

if extension==""
    %add separator if necessary
    if oldPath == "" || extractBetween(oldPath,strlength(oldPath),strlength( oldPath))~=string(filesep)
        newPath =oldPath + string(filesep);
    end
end


end


