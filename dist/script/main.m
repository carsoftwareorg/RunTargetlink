%% Check and print options
if ~exist('strBuildOption', 'var')
    error('action string not set');
end

if ~exist('strModelName', 'var')
    error('model Name string not set');
end

if ~exist('strProjectPath', 'var')
    error('projectPath string not set');
end

if ~exist('strTargetDirPath', 'var')
    error('targetDirPath string not set');
end

disp(strBuildOption);
disp(strModelName);
disp(strProjectPath);
disp(strTargetDirPath);

%% Interprete action
target = mbsd.targetlink.internal.Model.CODE_HOST;
bGenerateCode = false;
bCompileCode = false;
switch(lower(strBuildOption))
    case 'generatecode'
        bGenerateCode = true;
    case 'buildsil'
        bGenerateCode = true;
        bCompileCode = true;
    case 'buildpil'
        target = mbsd.targetlink.internal.Model.CODE_TARGET;
        bGenerateCode = true;
        bCompileCode = true;
    case 'compilesil'
        bCompileCode = true;
    case 'compilepil'
        target = mbsd.targetlink.internal.Model.CODE_TARGET;
        bCompileCode = true;
    otherwise
        error('inputed build action is not supported');
end

%% Prepare environment
oldBatchMode = tlBatchMode('Get');
if ~oldBatchMode
    tlBatchMode('Set', true);
end
ds_error_clear();
bOpenedProject = false;
bOpenedModel = false;
if ~isempty(strProjectPath)
    oProject = openProject(strProjectPath);
    bOpenedProject = true;
end
if ~bdIsLoaded(strModelName)
    load_system(strModelName);
    bOpenedModel = true;
end
ds_error_display('ShowDialog', 'off', 'ClearMessage', 'on');

%% Execute action
bSuccess = true;
oModel = mbsd.targetlink.Model(strModelName);
if bGenerateCode
    bSuccess = oModel.generateCode(target);
end
if bSuccess && bCompileCode
    bSuccess = oModel.compile(target);
end

if bSuccess && bGenerateCode
    bSuccess = oModel.exportCode(fullfile(strTargetDirPath, 'code'));
end

if bSuccess
    bSuccess = oModel.copyGeneratedFiles(fullfile(strTargetDirPath, 'generated'));
end

%% Interprete result

ds_error_display('ShowDialog', 'off', 'ClearMessage', 'on');

if bSuccess
    disp('action succeeded')
else
    disp('action failed')
end

% save dd for following compile sil step
if bSuccess && bGenerateCode
  save_system(strModelName);
  dsdd('Save');
end

%% Cleanup
if bOpenedModel
    bdclose(strModelName);
end
if bOpenedProject
    oProject.close();
    clear('oProject');
end
if ~oldBatchMode
    tlBatchMode('Set', oldBatchMode);
end
clear('oldBatchMode')
clear('bOpenedModel')
clear('bOpenedProject')
clear('bSuccess')
clear('bSuccess')
clear('codeTargetDirPath')
clear('oModel')
clear('bGenerateCode')
clear('bCompileCode')
clear('target')
