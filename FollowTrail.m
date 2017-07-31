function [ state_trail, linear_trail ] = FollowTrail( state_choices, start_state, varargin )
%[state_trail,linear_trail]=FOLLOWTRAIL(state_choices,start_state,dim)
%Follow a trail of states: state(t+1) = state_choices(state(t), t)
%   state_choices = choice of next state given current state
%   start_state   = state to start from
%   dim           = which dimension is indexed by states? default: 1

persistent p
if isempty(p)
    p = inputParser;
    p.FunctionName = 'FollowTrail';
    p.StructExpand = true;
    p.KeepUnmatched = false;
    p.addRequired('state_choices', @(x) validateattributes(x, {'double'},...
        {'2d', 'positive', 'integer'}, 'FollowTrail', 'state_choices', 1));
    p.addRequired('start_state', @(x) validateattributes(x, {'double'},...
        {'scalar', 'positive', 'integer'}, 'FollowTrail', 'start_state', 2));
    p.addOptional('dim', 1, @(x) validateattributes(x, {'double'},...
        {'scalar', 'positive', 'integer', '<=', 2}, 'FollowTrail', 'dim', 3));
end
p.parse(state_choices, start_state, varargin{:});
if p.Results.dim == 2
    state_choices = state_choices';
end

N = size(state_choices, 1);
T = size(state_choices, 2);

if any(state_choices(:) > N)
    msg = ['\nElements of state_choices must be <=%d.\n'...
        'The following elements failed:'  sprintf(' %d', find(state_choices > N)) '.'];
    error('MATLAB:badsubscript', ['Index exceeds matrix dimensions.' msg], N, find(state_choices > N));
end

state_trail = zeros(1, T);

state_trail(1) = start_state;

for t = 2:T
    state_trail(t) = state_choices(state_trail(t-1), t-1);
end


linear_trail = sub2ind([N, T], state_trail, 1:T);

end

