using Statistics, Distributions, Plots


function simulation_binom(reps, n)
    binom = Binomial(50, 0.25)
    out = [mean(rand(binom, n)) for i in 1:reps]
    return out
end

μ = mean(Binomial(50, 0.25))
σ = sqrt(var(Binomial(50, 0.25)))

samples = [simulation_binom(10000, n) for n in [50, 100, 1000]]

xgrid = range(11, 14, 1000)


histogram(samples[1], normalize = true, alpha = 0.5, label = "Sample Mean, N = 50")
plot!(xgrid, pdf.(Normal(μ, σ/sqrt(50)), xgrid), linewidth = 2, label = false)

histogram!(samples[2], normalize = true, alpha = 0.5, label = "Sample Mean, N = 100")
plot!(xgrid, pdf.(Normal(μ, σ/sqrt(100)), xgrid), linewidth = 2, label = false)

histogram!(samples[3], normalize = true, alpha = 0.5, label = "Sample Mean, N = 1000")
plot!(xgrid, pdf.(Normal(μ, σ/sqrt(1000)), xgrid), linewidth = 2, label = false)
