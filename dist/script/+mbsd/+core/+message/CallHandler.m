classdef CallHandler
    %CALLHANDLER The call handler
    
    methods(Static)
        
        function [bSuccess, varargout] = call(hFunction, varargin)
            % Calls a function and collects exceptions as well as TL and DD
            % messages
            %
            % SYNTAX
            %   bSuccess = obj.call(hFunction, varargin)
            %
            % INPUT ARGUMENTS
            %   hFunction
            %               Function handle, the function to call.
            %   varargin
            %               The parameters for hFunction.
            %
            % OUTPUT ARGUMENTS
            %   bSuccess
            %               Logical, true if the code generation was successful.
            %   varargout
            %               The output for hFunction.

            % Save current TL message state to recover it later and merge it with newly added messages during hFunction
            msgData = ds_error_get('CurrentState');

            try
                bSuccess = true;
                switch nargout
                    case 0
                        hFunction(varargin{:});
                    case 1
                        hFunction(varargin{:});
                    otherwise
                        varargout = hFunction(varargin{:});
                end
            catch ex
                causeName = ex.stack(1).name;
                messageHead = sprintf('Uncaught error: %s', causeName, ex.message);
                ds_error_register(messageHead, ...
                     'Title', 'MBSD.SDK uncaught error', ...
                     'MessageType', 'error');
                bSuccess = false;
            end
            
            % Recover previously added messages before we add the new messages that came up during hFunction 
            ds_error_merge(msgData);
            
            % Take over all TL messages
            tlMessages = ds_error_get('AllMessages');

            % Take over all DD messages, usually not as important as TL
            % messages
            ddMessages = dsdd('GetMessageList');

            % Interprete messages
            if any(strcmpi({{tlMessages.type}; {ddMessages.type}},'error')) || any(strcmpi({{tlMessages.type}; {ddMessages.type}},'fatal'))
                bSuccess = false;
            end
        end
    end
end

