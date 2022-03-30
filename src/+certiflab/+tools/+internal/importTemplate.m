
function [errorFlag,exception] = importTemplate( templateFile,newFile, modification )
%IMPORTTEMPLATE - import and modify a template m-file to another one
%
%   SYNTAX:
%       [errorFlag,msg] = importTemplate( templateFile,newFile,
%       modification ) create a new file newFile based on templateFile
%       with transformation defined in transformation
%
%   INPUTS:
%       templateFile    absolute Path of template file as a string
%                       scalar. Extension shall be .m. File shall exist.
%
%       new File        Absolute Path of the new file as a string scalar.
%                       Extension shall be .m
%
%       modification    string array with two colums and N rows. N is the
%                       number of modification. First column defined the patern to search
%                       and the secund column the replacement text
%
%   OUTPUTS:
%       errorFlag       Boolean Scalar. True if the process failed else
%                       false
%
%       exception       Error message as a MException scalar object
%
%   EXAMPLES:
%       [chk,ME]=importTemplate("template.m","test001.m",["patern01_","functionName001";"patern02_","functionName002"])
%
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% I/O MANAGEMENT
try
    %check templateFile
    certiflab.check.checkStringScalar(templateFile,"VariableName","templateFile"); % data type
    certiflab.check.checkExtension(templateFile,".m","VariableName","templateFile"); % extension
    certiflab.check.checkFileExistence(templateFile,"VariableName","templateFile"); % existence
    
    %check newFile
    certiflab.check.checkStringScalar(newFile,"VariableName","newFile"); % data type
    certiflab.check.checkExtension(newFile,".m","VariableName","newFile"); % extension
    
    % check modification
    assert(isstring(modification),"modification shall be a string array.\nCurrent class : %s",class(modification));
    assert(size(modification, 2)==2, "modification shall be a Nx2 string array");
    
catch ME
    errorFlag = true;
    exception = MException("importTemplate:badInput",ME.message);
    return
end


%% read and modify the template

try
    % read the template
    fileContent = matlab.internal.getCode(char(templateFile)); % m code as a global char
 
    % modification to string array
    if (isempty(fileContent))
        error("The file %s contains nothing",templateFile);
    else
        fileContent = string(strsplit(fileContent, {'\r\n','\n', '\r'}, 'CollapseDelimiters', false)');
    end
    
    % apply modificaiton
    for idx = 1: size(modification,1)
        fileContent = strrep(fileContent,modification(idx,1),modification(idx,2));
    end
   
catch ME
    errorFlag = true;
    exception = MException("importTemplate:readTemplate",ME.message);
    return
end

%% WRITE NEW FILE

% write file
try
    % file is written
    fid = fopen(newFile,'w+');
    fprintf(fid,"%s\n",fileContent);
    fclose(fid);
    
catch ME
    fclose(fid);
    errorFlag = true;
    exception = MException("importTemplate:writeFile",ME.message);
    return
end

%% TEARDOWN
    errorFlag = false;
    exception = MException.empty();

end

%------------- END OF CODE --------------
