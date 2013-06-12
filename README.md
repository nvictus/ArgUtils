ArgUtils
========

Argument parsing utilities for MATLAB

Particularly useful for functions that use varargin
- Use `ArgUtils.assignVars()` to assign variables _sequentially_
- Use `ArgUtils.assignArgs()` to assign _named_ variables. This allows using either struct inputs or providing sequences of values followed by keyword-matching name-value pairs in any order.

There are also options to specify:
- required input arguments
- string prefixes on keywords to prevent name collisions with string values

```matlab
function example(varargin)
import ArgUtils.*

% default values for input arguments
defaults.x = [];
defaults.y = 2;
defaults.z = 3;
defaults.state = 'off';
defaults.tol = 0.001;

[x,y,z,state,tol] = assignArgs( defaults, varargin, 'Expand', true, 'Required', {'x'} )
...
end
```

```matlab
>> example(100, 200, 'tol', 0.999, 'z', 'charlie')

x =
  100

y =
  200
  
z =
'charlie'

state =
'off'

tol =
  0.999
```
