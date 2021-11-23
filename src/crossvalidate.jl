"""
Generates uniformly-spaced cross-validation splits, subject to the constraint that
the testing data must be contiguous.

# Arguments:
- `t_range`: Time points to use for training and testing
- `n_splits`: Number of cross-validation splits
- `train_frac`: Fraction of data that should be testing
"""
function generate_cv_splits(t_range, n_splits, train_frac)
    @assert(0 < train_frac <= 1, "Training fraction must be between 0 and 1.")
    @assert(n_splits > 1, "Must have at least two splits.")
    splits = []
    train_len = Int32(ceil(train_frac * length(t_range)))
    test_len = length(t_range) - train_len
    loc = 1
    spacing = (length(t_range) - test_len) / (n_splits - 1)
    for i=1:n_splits
        test_rng = t_range[loc:loc+test_len-1]
        train_rng = [t for t in t_range if !(t in test_rng)]
        push!(splits, (train_rng, test_rng))
        loc += spacing
    end
    return splits
end

"""
Adds sampling to a `training set` with a certain `sample_density` at time points in `t_range`.
"""
function add_sampling(training_set, sample_density, t_range)
    len_train = length(training_set)
    len_test = length(t_range) - len_train
    frac_train = len_train / length(t_range)
    frac_sample = frac_train * sample_density
    n_sample = 1 / frac_sample
    new_train = deepcopy(training_set)
    count = 1
    for t=t_range
        if count > n_sample
            count = 1
            push!(new_train, t)
        end
        count += 1
    end
    new_test = [t for t in t_range if !(t in training_set)]
    return (new_train, new_test)
end

"""
Removes beginning of each video from total timepoints `t_range` given video splits `idx_splits`,
    to avoid `ewma` issues.
"""
function rm_dataset_begin(t_range, idx_splits; thresh=50)
    return [t for t in t_range if !any([abs(t-s[1]) <= thresh for s in idx_splits])]
end

"""
Removes splits with low training behavior variation.

# Arguments:
- `splits`: Proposed train/test splits
- `behaviors`: Behaviors
- `variation_thresh`: Fraction of total variation that must be included in training set.
- `varation_function` (default `cost_rss`): Function to use to compute variation.
"""
function rm_low_variation(splits, behaviors, variation_thresh; variation_fn=cost_rss)
    new_splits = []
    for split in splits
        train = splits[1]
        if !any([variation_fn(behavior[train], mean(behavior)) < variation_thresh * variation_fn(behavior, mean(behavior))
                for behavior in behaviors])
            push!(new_splits, split)
        end
    end
    return new_splits
end

