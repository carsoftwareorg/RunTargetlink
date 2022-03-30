function checkStringScalar( data2test,varargin )
%checkStringScalar - assert if the data is a scalar string
%
%   SYNTAX:
%
%       checkStringScalar(data2test) raises an error if data is not a scalar [1x1].
%
%       checkStringScalar(data2test,'ErrorID', ID) raises an error if data is not a
%       string scalar [1x1] with the error identification ID.
%
%       checkStringScalar(data2test,'VariableName', objectName) raises an error if data is not a
%       string scalar [1x1] with the name of the name of the tested
%       object objectName       
%
%   INPUTS:
%
%       data2test              variable to test 
%
%   OPTIONAL INPUT ARGUMENTS
%
%       "ErrorID", ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkStringScalar:data2test:NotStringScalar)
%
%       "VariableName", objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "data2test")  
%
%   OUTPUTS:
%
%       Not Applioable
%
%   EXAMPLES:
%
%       certiflab.check.checkStringScalar("abc")
%       certiflab.check.checkStringScalar(["abc" "def"],"ErrorID","test001:test","VariableName","test")

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.

%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkStringScalar:data2test:NotStringScalar","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkStringScalar:ErrorID:BadClass",certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% varibaleName
assert(isStringScalar(opt.VariableName),"checkStringScalar:VariableName:BadClass",certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

certiflab.check.checkDataType(data2test,"string","VariableName",opt.VariableName,"ErrorID",opt.ErrorID);

certiflab.check.checkScalar(data2test,"VariableName",opt.VariableName,"ErrorID",opt.ErrorID);


end

%------------- END OF CODE --------------
