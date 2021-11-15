module AnalysisBase

using InformationMeasures, GLMNet, StatsBase, Statistics

include("decoder.jl")
include("mutual_info.jl")
include("util.jl")
include("crossvalidate.jl")
include("metric.jl")

export
    # decoder.jl
    train_decoder,
    # mutual_info.jl
    compute_mutual_information_dict,
    # util.jl

    # metric.jl
    cost_rss,
    cost_abs,
    cost_mse,
    cost_cor,
    reg_var_L1,
    reg_var_L2,
    # crossvalidate.jl
    add_sampling,
    generate_cv_splits,
    rm_dataset_begin,
    rm_low_variation

end # module
