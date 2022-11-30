using Statistics, Plots, Distributions

# Take normal distribution for illustration
μ = 0
σ² = 1

function simulation(reps, dist, g)
    out = zeros(reps)

    for i in 1:reps
        sample = rand(dist)
        out[i] = g(mean(sample))
    end

    return out
end

function simulation(reps, dist)
    out = zeros(reps)

    for i in 1:reps
        sample = rand(dist)
        out[i] = mean(sample)
    end

    return out
end

function plot_limit(μ, reps)

    dist = Normal(μ, σ²)
    dist2 = Normal(μ, σ²)

    xbar = simulation(reps, dist) 
    xbar_abs = simulation(reps, dist, abs)

    x = range(μ-4, μ+4, 200)    
    
    histogram(xbar, normalize=true, label = "Sample Mean (μ = $μ)")
    histogram!(xbar_abs, normalize=true, label = "Absolute Value (μ = $μ)")
    plot!(x, pdf.(dist, x), label = "Asymptotic Distribution (μ = $μ)")
    if μ < 0 
        plot!(x, pdf.(dist2, x), label = "Asymptotic Distribution (μ = $μ)")
    end
    plot!(legend=:topleft)

end    

plots = [plot_limit(i, 100000) for i in [-2, 0, 2, 10]]

plots[1]
plots[2]
plots[3]
plots[4]

# Check validity of CI
function compute_ci(mid, α, n, se)
    ci_low = mid - sqrt(n)^-1 * quantile(Normal(), 1-α/2) * se
    ci_hi = mid + sqrt(n)^-1 * quantile(Normal(), 1-α/2) * se

    return (ci_low, ci_hi)
end

S_square(x) = (length(x)-1)^-1 * sum((x .- mean(x)).^2) 

function covrate(μ, reps, n)
    
    dist = Normal(μ, 1)
    cis = zeros(reps, 2)

    for i in 1:reps
        draw = rand(dist, n)
        absmean = abs(mean(draw))
        se = S_square(draw)
        (cis[i, 1], cis[i, 2]) = compute_ci(absmean, 0.05, n, se)
    end

    covrate = mean(cis[:,1] .< abs(μ) .< cis[:, 2])

    return covrate
end

μ_grid = range(-2, 2, 20)

covrates = [covrate(i, 10000, 10000) for i in μ_grid]

scatter(μ_grid, covrates, label = "Coverage Rates")

covrate(0, 10000, 100000)

## // TODO this shouldn't be the case? coverage rate should be lower around 0
