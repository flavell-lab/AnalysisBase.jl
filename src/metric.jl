function cost_rss(y, y_pred)
    sum((y .- y_pred) .^ 2)
end

function cost_abs(y, y_pred)
    sum(abs.(y .- y_pred))
end

function cost_mse(y, y_pred)
    mean((y .- y_pred) .^ 2)
end

function cost_cor(y, y_pred)
    - cor(y, y_pred)
end

function reg_var_L1(list_θ, list_σ2)
    sum(abs.(list_θ ./ (list_σ2 .+ 1)))
end

function reg_var_L2(list_θ, list_σ2)
    sum((list_θ ./ (list_σ2 .+ 1)) .^ 2)
end
