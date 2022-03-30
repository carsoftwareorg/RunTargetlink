function checkDimension( data2test,expectedDimension,varargin )
%checkDimension - assert if the data is a vector
%
%   SYNTAX:
%
%       checkDimension(data) raises an error if the dimension of data2test is not equal to expectedDimension.
%
%       checkDimension(data,'ErrorID', ID) raises an error if the dimension of data2test is not equal to expectedDimension.
%       with the error identification ID.
%
%       checkDimension(data,'VariableName', objectName) aises an error if the dimension of data2test is not equal to expectedDimension.
%       vector [1xn] or [nx1] with the name of the name of the tested
%       object objectName.  
%
%       NOTA BENE : this function is available for the following class :
%           'logical','string','int8','uint8','int16','uint16','int32',...
%            'uint32','int64','uint64','single', 'double' or custom class
%            derived from the previous one.
%
%   INPUTS:
%
%       data2test               variable to test
%       expectedDimension       double vector with two elements (2x1 or 1x2) that represents
%                               the expected size of the tested object
%
%   OPTIONAL INPUT ARGUMENTS
%
%       'ErrorID', ID                   ID defines the custom error identificator 
%                                       with a scalar string (default :  checkDimension:data2test:badDimension)
%
%       'VariableName', objectName      objectName provide the name of the object for 
%                                       the error message as a string scalar (default "data2test")  
%
%   OUTPUTS:
%
%       Not applicable
%
%   EXAMPLES:
%
%       certiflab.check.checkDimension("abc",[1 1])
%       certiflab.check.checkDimension("abc",[2 1],"errorID","test001:test")
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%TODO : analyze with empty array

%% PARAMETER

%% I/O MANAGEMENT

% data type of expectedDataType

%expected dimension
assert(isa(expectedDimension,'double'),"checkDimension:expectedDimension:BadClass",...
    certiflab.tools.internal.errorMSG4Class("expectedDimension",expectedDimension,"double"));

assert(isvector(expectedDimension) && length(expectedDimension)==2,"checkDimension:expectedDimension:badDimension",...
    certiflab.tools.internal.errorMSG4Vector("expectedDimension",expectedDimension,2))


%% OPTION MANAGEMENT

% parse varargin
opt = certiflab.tools.internal.parseVarargin(["ErrorID","VariableName"],{"checkDimension:data2test:badDimension","data2test"}, varargin{:}); %#ok<CLARRSTR>

% errorID
assert(isStringScalar(opt.ErrorID),"checkDimension:ErrorID:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("ErrorID",opt.ErrorID));

% VariableName
assert(isStringScalar(opt.VariableName),"checkDimension:VariableName:BadClass",...
    certiflab.tools.internal.errorMSG4stringScalar("VariableName",opt.VariableName));


%% EXECUTION

ME = certiflab.exception.createException(opt.ErrorID,... %error ID
    sprintf("The dimension of <%s> shall be [%ix%i].",opt.VariableName,expectedDimension(1),expectedDimension(2)),... % requirement
    sprintf("The current dimension of <%s> is [%ix%i].",opt.VariableName,size(data2test,1),size(data2test,2))); % diagnostic

assert(all(expectedDimension==size(data2test)), opt.ErrorID , ME.message);



end

%------------- END OF CODE --------------
