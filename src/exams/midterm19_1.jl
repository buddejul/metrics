using Plots, Statistics, Random, Distributions, Expectations

α = 2
dist = Pareto(α)

α/(α-1)
mean(dist)
# Note the variance does not exist for α = 2 (only for α > 2): 
var(dist)

α_analog(x) = mean(x)/(mean(x)-1)
α_mle(x) = length(x)/sum(log.(x))

α_analog(x)
α_mle(x)

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

function simulate(α, n, reps)
    analog = zeros(reps)
    mle = zeros(reps)

    for i in 1:reps
        sample = sample_pareto(α, n)
        analog[i] = α_analog(sample)
        mle[i] = α_mle(sample)
    end

    return (analog = analog, mle = mle)
end

function plot_estimators(n)
    results = simulate(2, n, 10000)

    histo = histogram(results.analog, label = "Sample Analog", plot_title = "N = $n", fillalpha = 0.5)
    histogram!(results.mle, label = "MLE", fillalpha = 0.5)
    histogram!(legend=:topleft)

    return histo
end

plots = [plot_estimators(n) for n in [100, 1000, 10000]]
plots[1]
plots[2]
plots[3]

plot(plots[1], plots[2], plots[3], layout = (1, 3))
