function varargout = expand(s)

values = struct2cell(s);
[varargout{1:nargout}] = values{:};

end