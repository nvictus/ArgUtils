function test()

test_assignVars();

test_assignArgs();

test_assignArgs_required();

test_assignArgs_expand();

test_assignArgs_prefix();

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

% ensure proper bookkeeping when inputs are not perfect matches
inputs = {'X', 1, 'tol',0};
args = assignArgs(args, inputs, 'Require',{'x'});
assert(args.x == 1 && args.tol ==0 && args.size==inf);

inputs = {'x', 1, 't',0};
args = assignArgs(args, inputs, 'Require',{'tol'});
assert(args.x == 1 && args.tol ==0 && args.size==inf);

inputs = struct('X', 1, 'tol',0);
args = assignArgs(args, inputs, 'Require',{'x'});
assert(args.x == 1 && args.tol ==0 && args.size==inf);

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
end


function assertThrows(error_id, nout, func, varargin)

out = cell(nout,1);
try
    [out{1:nout}] = feval(func, varargin{:});
catch err
    assert(strcmp(err.identifier, error_id));
end

end
