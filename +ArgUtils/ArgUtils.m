classdef ArgUtils
    %ARGUTILS 
    %   Somewhere to store constants...
    
    properties (Constant)
        VERSION = '1.0'

        % error "types" inspired by python standard lib
        TypeError  = 'Exception:StandardError:TypeError' %Exception.TypeError
        ValueError = 'Exception:StandardError:ValueError' %Exception.ValueError
        KeyError   = 'Exception:StandardError:KeyError' %Exception.KeyError
    end
    

end

