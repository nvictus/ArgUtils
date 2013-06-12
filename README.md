ArgUtils
========

Argument parsing utilities for MATLAB

```matlab
function  example(varargin)

import ArgUtils.*
args.x = [];
args.y = 2;
args.z = struct('a',1,'b',2);
args.state = 'off';
args.tol = 0.001;

[x,y,z,state,tol] = assignArgs( args, varargin, 'Expand', true);

...

end
```
