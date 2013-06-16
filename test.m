function test()

test_assignVars();

test_assignArgs();

test_assignArgs_required();

test_assignArgs_expand();

test_assignArgs_prefix();

test_assignArgs_badInput();

test_assignArgs_edgeCases();

disp('Passed! :)');

end

function test_assignVars()
import ArgUtils.*

inputs = {};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x=='a' && y=='b' && z=='c');

inputs = {1,2,3};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x==1 && y==2 && z==3);

inputs = {1,2};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x==1 && y==2 && z=='c');

inputs = {1};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x==1 && y=='b' && z=='c');

inputs = {1, [], 3};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x==1 && y=='b' && z==3);

inputs = {[], [], 3};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x=='a' && y=='b' && z==3);

inputs = {1, 2, []};
[x,y,z] = assignVars({'a','b','c'}, inputs);
assert(x==1 && y==2 && z=='c');

inputs = {1, 2, 3};
assertThrows(ArgUtils.TypeError, 4, @assignVars, {'a','b','c'}, inputs);

inputs = {1, 2, 3, 4};
assertThrows(ArgUtils.TypeError, 3, @assignVars, {'a','b','c'}, inputs);

end


function args = test_assignArgs()
import ArgUtils.*
args.x = [];
args.tol = 99;
args.size = inf;

inputs = {5, 'size', 10};
args = assignArgs(args, inputs);
assert(args.x==5 && args.tol==99 && args.size==10);

inputs = struct('x',5, 'size',10);
args = assignArgs(args, inputs);
assert(args.x==5 && args.tol==99 && args.size==10);

% string matching is case-insensitive, allows abbreviation
inputs = struct('X',5, 'si',10);
args = assignArgs(args, inputs);
assert(args.x==5 && args.tol==99 && args.size==10);

end


function test_assignArgs_expand()
import ArgUtils.*
args.x = [];
args.tol = 99;
args.size = inf;

inputs = {5, 'size', 10};
[x,tol,size] = assignArgs(args, inputs, 'Expand', true);
assert(x==5 && tol==99 && size==10);

inputs = {5, 'size', 10};
[x,tol] = assignArgs(args, inputs, 'expand', true);
assert(x==5 && tol==99);

inputs = struct('x',5, 'size',10);
[x,tol] = assignArgs(args, inputs, 'expand', true);
assert(x==5 && tol==99);

inputs = {1,100,-inf};
[x,tol,size] = assignArgs(args, inputs, 'Expand', true);
assert(x==1 && tol==100 && size==-inf);

inputs = {'x',1, 'tol',100, 'size',-inf};
[x,tol,size] = assignArgs(args, inputs, 'Expand', true);
assert(x==1 && tol==100 && size==-inf);
end


function args = test_assignArgs_required()
import ArgUtils.*
args.x = [];
args.tol = 99;
args.size = inf;

inputs = {};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'x'});

inputs = {'tol',0};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'x'});

inputs = struct('tol',0);
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'x'});

inputs = {'x', 1, 'tol',0};
args = assignArgs(args, inputs, 'Require',{'x'});
assert(args.x == 1 && args.tol ==0 && args.size==inf);

% ensure proper bookkeeping of assigned args when inputs are not perfect matches
inputs = {'X', 1, 'tol',0};
assertNotThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'x'});

inputs = {'x', 1, 't',0};
assertNotThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'tol'});

inputs = struct('X', 1, 'tol',0);
assertNotThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs, 'Require', {'x'});

end


function test_assignArgs_prefix()
import ArgUtils.*
args.x = [];
args.y = 2;
args.z = 3;
args.state = 'off';
args.tol = 0.001;

inputs = {'x', 'state', '-z', 'tol', '-state', 'thinking'};
[x,y,z,state,tol] = assignArgs( args, inputs, 'Expand', true, 'Prefix', '-');
assert( strcmp(x,'x') &&...
        strcmp(y,'state') && ...
        strcmp(z,'tol') &&...
        strcmp(state,'thinking') &&...
        tol==0.001);

% with struct input, prefix option should have no effect
inputs = struct('x','x', 'y','state', 'z','tol', 'state','thinking');
[x,y,z,state,tol] = assignArgs( args, inputs, 'Expand', true, 'Prefix', '-');
assert( strcmp(x,'x') &&...
        strcmp(y,'state') && ...
        strcmp(z,'tol') &&...
        strcmp(state,'thinking') &&...
        tol==0.001);

% input string shorter than prefix
inputs = {'a', 3};
out = assignArgs( args, inputs, 'Prefix', '--');
assert( strcmp(out.x,'a') &&...
        out.y==3 );
assertNotThrows('MATLAB:badsubscript', 1, @assignArgs, args, inputs);

end


function test_assignArgs_badInput()
import ArgUtils.*
args.x = [];
args.y = 2;
args.z = 3;
args.state = 'off';
args.tol = 0.001;

inputs = {'x',1, 'y',2, 'z'};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs);

inputs = {'x',1, 'y',2, [1 2 3]};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs);

inputs = {'y',200, 'z', 300, 'y', 400};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs);

inputs = {'y',200, 'foo', 300};
assertThrows(ArgUtils.KeyError, 1, @assignArgs, args, inputs);

inputs = struct('y',200, 'foo', 300);
assertThrows(ArgUtils.KeyError, 1, @assignArgs, args, inputs);

% too many inputs
inputs = {100, 200, 300, 'on', 0.999, 100};
assertThrows(ArgUtils.TypeError, 1, @assignArgs, args, inputs);

% too many outputs (rhs returns singleton)
inputs = {100, 200, 300, 'on', 0.999};
assertThrows(ArgUtils.TypeError, 5, @assignArgs, args, inputs);

% too many outputs (rhs returns expanded)
inputs = {100, 200, 300};
assertThrows(ArgUtils.TypeError, 6, @assignArgs, args, inputs, 'Expand', true);

end

function test_assignArgs_edgeCases()
import ArgUtils.*
args.x = 0;
args.tol = 99;
args.size = inf;

% no inputs
inputs = {};
[x,tol,size] = assignArgs(args, inputs, 'Expand', true);
assert(x==0 && tol==99 && size==inf);

% no outputs
clearvars x tol size
inputs = {1, 2, 3};
assignArgs(args, inputs);
assert(~logical(exist('x','var')));
assignArgs(args, inputs, 'Expand', true);
assert(logical(exist('x','var')));

% no defaults (for whatever reason...)
inputs = {};
assertNotThrows(ArgUtils.TypeError, 1, @assignArgs, struct([]), inputs);
assertNotThrows(ArgUtils.TypeError, 0, @assignArgs, struct([]), inputs, 'Expand', true);
out = assignArgs(struct([]), inputs);
assert(isstruct(out) && isempty(out));
out = {};
[out{:}] = assignArgs(struct([]), inputs, 'Expand', true);
assert(isempty(out));

% empty keyword
inputs = {'x', 1, '', 3};
assertThrows(ArgUtils.KeyError, 1, @assignArgs, args, inputs);

inputs = {'-',3};
assertThrows(ArgUtils.KeyError, 1, @assignArgs, args, inputs, 'Prefix', '-');
end


function assertThrows(error_id, nout, func, varargin)

out = cell(nout,1);
iscaught = false;
try
    [out{1:nout}] = feval(func, varargin{:});
catch err
    iscaught = strcmp(err.identifier, error_id);
end
assert(iscaught);

end

function out = assertNotThrows(error_id, nout, func, varargin)

out = cell(1,nout);
iscaught = false;
try
    [out{1:nout}] = feval(func, varargin{:});
catch err
    iscaught = strcmp(err.identifier, error_id);
end
assert(~iscaught);

end
