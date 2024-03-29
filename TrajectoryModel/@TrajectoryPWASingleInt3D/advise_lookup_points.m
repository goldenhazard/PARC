function lookup_points = advise_lookup_points(obj, varargin)

kwargs = parse_function_args(varargin{:});
kwargs = check_sanity_and_set_default_kwargs(kwargs, ...
    "required_key", ["state_lookup", "goal"]);

goal         = kwargs.goal; % goal center
state_lookup = kwargs.state_lookup;

states_array  = flatten_grid_to_array("grids", state_lookup);

N_lookup      = length(state_lookup);
lookup_points = cell(N_lookup, 1);

for i = 1:size(states_array, 1)
    state = states_array(i, :);

    % Give maximum velocity in the direction of goal - current_state
    dx    = goal - state; dx = dx';
    param_bound_arr = cat(1, obj.params_bound{:});
    param_max       = param_bound_arr(:, 2);

    ratio           = max(abs(dx)./param_max);
    param_expert    = dx / ratio;

    state_param     = [state'; param_expert];
    
    lookup_points{i} = state_param;
end

end
