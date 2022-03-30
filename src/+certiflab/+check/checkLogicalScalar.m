function checkLogicalScalar( data2test,varargin )
%checkLogicalScalar - assert if the data is a scalar logical
%
%   SYNTAX:
%
%       checkLogicalScalar(data2test) raises an error if data is not a logical [1x1].
%
%       checkLogicalScalar(data2test,'ErrorID', ID) raises an error if data is not a
%       string logical [1x1] with the error identification ID.
%
%       checkLogicalScalar(data2test,'VariableName', objectName) raises an error if data is not a
%       string logical [1x1] with the name of the name of the tested
%       object objectName       
%
%   INPUTS:
%
%       data2test              variable to test 
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkLogicalScalar:data2test:notALogicalScalar)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "data2test")  
%   OUTPUTS:
%
%       Not applicable
%
%   EXAMPLES:
%
%       certiflab.check.checkLogicalScalar(true)
%       certiflab.check.checkLogicalScalar([true false],"ErrorID","test001:test","VariableName","test")

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],...
    {"checkLogicalScalar:data2test:notALogicalScalar","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkLogicalScalar:ErrorID:badClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% errorID
assert(isStringScalar(opt.VariableName),"checkLogicalScalar:VariableName:dadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

certiflab.check.checkDataType(data2test,"logical","VariableName",opt.VariableName,"ErrorID",opt.ErrorID);

certiflab.check.checkScalar(data2test,"VariableName",opt.VariableName,"ErrorID",opt.ErrorID);

end

%------------- END OF CODE --------------
