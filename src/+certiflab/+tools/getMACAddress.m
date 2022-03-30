function mac = getMACAddress( varargin )
%GETMACADDRESS - The default is to return one MAC address, likely for ethernet adaptor. If the
% optional input is provided and true, all MAC address are returned in cellstr.
% No internet connection is required for this to work.
% The optional 2nd output, if requested, is a struct with following fields:
%
%   Syntax:
%       mac = getMACAddress(); return 1st MAC in string - The format is like F0-4D-A2-DB-00-37 
%       for Windows, f0:4d:a2:db:00:37 otherwise.
%
%       mac = getMACAddress('allMAC',true); return all MAC on the computer The output is cell
%       even if only one MAC found.
%    
%   Outputs:
%       mac -   return 1st or all MAC in string scalar or string vector - 
%               The format is like F0-4D-A2-DB-00-37 for Windows, f0:4d:a2:db:00:37
%
%   Examples: 
%       mac = certiflab.tools.getMACAddress();
%       mac = certiflab.tools.getMACAddress('allMAC',true);
%

%   Author : MathWorks Consulting
%   Copyright 2021 The MathWorks, Inc.


%% I/O MANAGEMENT
% Default Parameter values:
    defaultAllMac         = false; %current operating path

% Register input parameters:
    p = inputParser;
    addParameter(p, 'AllMAC', defaultAllMac, @(x) islogical(x) && isscalar(x));
% Parse input arguments:
    parse(p, varargin{:});
    allMac            = p.Results.AllMAC;    


if ispc 
    % Windows Config
    [~, str] = jsystem({'ipconfig.exe' '/all'});
	str = regexprep(str, '\r', '');
    mac_expr = 'Physical Address.*?:\s*((?:[0-9A-F]{2}-){5}[0-9A-F]{2})\s';
    % adopt OS format preference
    fmt = '%02X-%02X-%02X-%02X-%02X-%02X'; 
elseif ismac 
    % MAC Config
    [~, str] = jsystem({'ifconfig'});
    mac_expr = '\n\s+ether\s+((?:[0-9a-f]{2}:){5}[0-9a-f]{2})\s';
    fmt = '%02x:%02x:%02x:%02x:%02x:%02x';
else
    % linux
    [err, str] = jsystem({'ip' 'address'}); % later Linux
    if ~err 
        % almost always
        mac_expr = '\s+link/ether\s+((?:[0-9a-f]{2}:){5}[0-9a-f]{2})\s';
    else
        % use ifconfig for old linux
        cmd = '/sbin/ifconfig';
        if ~exist(cmd, 'file'), cmd = 'ifconfig'; end
        [~, str] = jsystem({cmd});
        mac_expr = '\s+HWaddr\s+((?:[0-9a-f]{2}:){5}[0-9a-f]{2})\s';
    end
    fmt = '%02x:%02x:%02x:%02x:%02x:%02x';
end
if allMac, [mac, ~] = regexp(str, mac_expr, 'tokens', 'start');
else,      [mac, ~] = regexp(str, mac_expr, 'tokens', 'start', 'once');
end
mac = [mac{:}];


% java method is OS-independent, more reliable than regexp, but often slower and
% miss eth1 seen at least 1 Ubuntu machine
if isempty(mac)
try %#ok
    if allMac, mac = {}; end
    % call java API
    ni = java.net.NetworkInterface.getNetworkInterfaces;
    while ni.hasMoreElements
        aa = ni.nextElement;
        a = aa.getHardwareAddress;
        if numel(a)~=6 || all(a==0), continue; end % not valid mac
        % from int8
        a = typecast(a, 'uint8'); 
        m = sprintf(fmt, a);
        if allMac, mac{end+1} = m; %#ok
        else, mac = m; break; % done after finding 1st
        end
    end
end
end
% If all attemps fail, give warning and return a random MAC
if isempty(mac)
    warning('MACAddress:RandomMAC', 'Returned MAC are random numbers');
    a = randi(255, [1 6], 'uint8');
    % set 8th bit for random MAC, likely meaningless
    a(5) = bitset(a(5), 1); 
    mac = sprintf(fmt, a);
    if allMac
        mac = string({mac});
    else
    mac = string(mac);    
    end
end

%change mac to string
mac = string(mac);

%check outputs
certiflab.check.checkStringVector(mac,"VariableName","mac","ErrorID","getMACAddress:badOutput");


end
%% faster than system: based on https://github.com/avivrosenberg/matlab-jsystem
function [err, out] = jsystem(cmd)
% cmd is cell str, no quotation marks needed for file names with space.
% internla function
try
    pb = java.lang.ProcessBuilder(cmd);
    pb.redirectErrorStream(true); % ErrorStream to InputStream
    process = pb.start();
    scanner = java.util.Scanner(process.getInputStream).useDelimiter('\A');
    if scanner.hasNext(), out = char(scanner.next()); else, out = ''; end
    err = process.exitValue; % err = process.waitFor() may hang
    if err, error('java.lang.ProcessBuilder error'); end
catch % fallback to system() if java fails like for Octave
    cmd = regexprep(cmd, '.+? .+', '"$0"'); % double quotes if with middle space
    [err, out] = system(sprintf('%s ', cmd{:}, '2>&1')); % Octave need 2>&1
end
end

%------------- END OF CODE --------------
