using Plots, Statistics, Distributions, Random

Random.seed!(2359112412)

θ_hat(x) = mean(x)
θ_tilde(x) = sqrt(0.5 * (1/length(x)) * sum(x.^2))

θ_hat(1)
θ_tilde(1)

se_hat(x) = sqrt(θ_hat(x)^2 / length(x))
se_tilde(x) = sqrt((5/4) * length(x)^-1 * θ_tilde(x)^2)

## Function to simulate estimators | θ
function simulate_estimators(n, reps, θ)

    θ_hats = zeros(reps)
    θ_tildes = zeros(reps)
    se_hats = zeros(reps)
    se_tildes = zeros(reps)

    for i in 1:reps
        sample = rand(Exponential(θ), n)
        θ_hats[i] = θ_hat(sample)
        θ_tildes[i] = θ_tilde(sample)
        se_hats[i] = se_hat(sample)
        se_tildes[i] = se_tilde(sample)
    end

    return (θ_hats = θ_hats, θ_tildes = θ_tildes, se_hats = se_hats, 
        se_tildes = se_tildes)
end

θ_hats, θ_tildes, ses_hats, ses_tildes = simulate_estimators(1000, 10000, 2)

function calculate_rej_prob(estimates, ses, θ, α)
    t = @. (estimates - θ) / ses
    reject = abs.(t) .> quantile.(Normal(), 1 - α/2) 
    return mean(reject)
end

calculate_rej_prob(θ_hats, ses_hats, 2, 0.05)

function simulate_β(θ; α = 0.05, n = 10000, reps = 10000)
    if θ < 0 throw(DomainError(θ, "θ must be strictly positive")) end
    θ_hats, θ_tildes, ses_hats, ses_tildes = simulate_estimators(n, reps, θ)

    β_hat = calculate_rej_prob(θ_hats, ses_hats, θ, α)
    β_tilde = calculate_rej_prob(θ_tildes, ses_tildes, θ, α)

    return (β_hat = β_hat, β_tilde = β_tilde)
end

# Check that rejection probabilities -> 1 as n -> infty when θ = 2
simulate_β(2; n = 100)
simulate_β(2; n = 1000)
simulate_β(2; n = 10000)

## Plot power function
θ_grid = range(0.5, 10, 100)
results = [simulate_β(θ; n = 100) for θ in θ_grid]
β_hat, β_tilde = [getindex.(results, i) for i in 1:2]

plot(θ_grid, β_hat, label = "Estimator: Sample Mean")
plot!(θ_grid, β_tilde, label = "Estimator: Second Moment")
plot!(xlabel = "θ", ylabel = "β(θ)")
plot!(legend=:topright)

# Plot for larger sample
θ_grid = range(0.5, 10, 100)
results = [simulate_β(θ; n = 10000) for θ in θ_grid]
β_hat, β_tilde = [getindex.(results, i) for i in 1:2]

plot(θ_grid, β_hat, label = "Estimator: Sample Mean")
plot!(θ_grid, β_tilde, label = "Estimator: Second Moment")
plot!(xlabel = "θ", ylabel = "β(θ)")
plot!(legend=:topright)
