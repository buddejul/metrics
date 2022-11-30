using Plots, Statistics, Distributions
using Optim

pareto = Pareto(2)
mean(pareto)
var(pareto) # note the variance only exists for α > 2

# Sampling use probability integral transform
pdf(x, α) = α / (x^(α+1))
inv_cdf(p, α) = (1-p)^(-(1/α)) # inverse Pareto(α) CDF (quantile function)

p_grid = range(0, 1, 100)

plot(p_grid, inv_cdf.(p_grid, 2), label = "Quantile Function Pareto (α = 2)")
plot!(legend=:topleft)

function sample_pareto(α, n)
    x = rand(Uniform(0,1), n)
    return inv_cdf.(x, α)
end

negll(α, x) = -(length(x) * log(α) - sum((α+1).*log.(x)))

function mle(x; lb=1, ub=10)
    f(α) = negll(α, x)
    return optimize(f, lb, ub).minimizer    
end

sample = sample_pareto(2, 100)
mle(sample)
mle_analytic(sample)

function simulate(reps, n; α=2)
    out = zeros(reps, 2)

    for i in 1:reps
        sample = sample_pareto(α, n)
        out[i, 1] = mle(sample)
        out[i, 2] = mle_analytic(sample)
    end

    return out
end

results = simulate(10000, 1000)

diff = results[:,1] .- results[:,2]

histogram(diff, label = "Difference: Numeric - Analytic")