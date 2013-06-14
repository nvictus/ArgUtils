ArgUtils
========

Argument parsing utilities for MATLAB

Particularly useful for functions that use varargin or structs of input parameters
- Use `ArgUtils.assignVars()` to assign variables _sequentially_
- Use `ArgUtils.assignArgs()` to assign _named_ variables. This accepts either struct input or cell-array input containing a sequence of values followed by keyword-matching name-value pairs in any order. Keywords are matched using MATLAB's string validator, so matching is case-insensitive and abbreviated keywords are acceptable as long as they can be matched unambiguously.

There are also options to specify:
- required input parameters
- string prefixes on keywords to prevent name collisions with string values

Examples
--------
Parse your `varargin`, like a boss!
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
```
```matlab
>> example(100, 200, 'tol', 0.999, 'z', 'zulu')

x =
   100

y =
   200

z =
zulu

state =
off

tol =
    0.9990


>> example('y',200, 'z',300)

Error using example: 
Required argument x is missing.
```
--

Parse an options struct, and get additional toppings...free!
```matlab
function example2(name, num_scoops, options)

default.size = 'large';
default.flavor = 'vanilla';
default.sprinkles = true;
default.whipped_cream = true;
default.syrup = true;
default.cherry_on_top = true;

options = ArgUtils.assignArgs( default, options )
...
```
--

Worried about string inputs clashing with argument names? Set a prefix for name keywords.
As a bonus, your function will now accept switches in command mode! You hacker, you...
```matlab
function example3(varargin)

default.url = 'www.imgur.com';
default.query = 'cats';

[url, query] = ArgUtils.assignArgs( default, varargin, 'Expand', true, 'Prefix', '-' );
...
```
```matlab
>> example3 -url www.github.com -query ArgUtils
```
```matlab
>> example3 -q url -u example.com
```

--

For simple sequential assignment (following the convention of the common "~exist or isempty" idiom to assign defaults), you can parse `varargin` with `assignVars()`.
```matlab
function example4(varargin)
[a,b,c] = ArgUtils.assignVars({1, 2, 3}, varargin)
...
```
```matlab
>> example4('alpha', 'bravo')
a =
alpha

b =
bravo

c =
   3

>> example4('alpha', [], 'charlie')
a =
alpha

b =
   2

c =
charlie
```
