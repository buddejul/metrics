using Plots, Distributions, Random, Statistics
using Expectations

# Choose some distribution with support on [0, 1] and  finite third absolute 
# moment
dist = Uniform(0, 1)

# Define expectations operator
E = expectation(dist)

μ_hat(x) = mean(x)

ci1lo(x, α) = μ_hat(x) - quantile.(Normal(), 1 - α/2)/(2*sqrt(length(x)))
ci1hi(x, α) = μ_hat(x) + quantile.(Normal(), 1 - α/2)/(2*sqrt(length(x)))

ci2lo(x, d) = μ_hat(x) - d/sqrt(length(x))  
ci2hi(x, d) = μ_hat(x) + d/sqrt(length(x))  

ci3lo(x, δ) = μ_hat(x) - quantile.(Normal(), 1 - δ/2)/(2*sqrt(length(x)))  
ci3hi(x, δ) = μ_hat(x) + quantile.(Normal(), 1 - δ/2)/(2*sqrt(length(x)))  

function simulation(reps, n, α, dist)

    μ = mean(dist)
    σ = sqrt(var(dist))
    λ = E(x -> abs(x^3)) # note abs is not necessary on [0, 1] support

    cbar = λ*σ^3

    ci1 = zeros(reps, 2)
    cover1 = Vector{Bool}(undef, reps)
    ci2 = zeros(reps, 2)
    cover2 = Vector{Bool}(undef, reps)
    ci3 = zeros(reps, 2)
    cover3 = Vector{Bool}(undef, reps)

    for i in 1:reps
        sample = rand(dist, n)
        ci1[i, 1] = ci1lo(sample, α)
        ci1[i, 2] = ci1hi(sample, α)

        cover1[i] = ci1[i, 1] <= μ <= ci1[i, 2]
        
        d = 1/(2*sqrt(α))

        ci2[i, 1] = ci2lo(sample, d)
        ci2[i, 2] = ci2hi(sample, d)

        cover2[i] = ci2[i, 1] <= μ <= ci2[i, 2]

        δ = α - (2 * 0.4748)/sqrt(length(sample))*cbar
        ci3[i, 1] = ci3lo(sample, δ)
        ci3[i, 2] = ci3hi(sample, δ)

        cover3[i] = ci3[i, 1] <= μ <= ci3[i, 2]
    end

    return (
        ci1 = ci1, covr1 = mean(cover1),
        ci2 = ci2, covr2 = mean(cover2),
        ci3 = ci3, covr3 = mean(cover3)
    )

end

result = simulation(10000, 10000, 0.05, dist)

histogram(result.ci1, label = ["CI 1: Low" "CI 1: Hi"], fillalpha = 0.5,
    color=:red)
histogram!(result.ci2, label = ["CI 2: Low" "CI 2: Hi"], fillalpha = 0.5,
    color=:green)
histogram!(result.ci3, label = ["CI 3: Low" "CI 3: Hi"], fillalpha = 0.5,
    color=:blue)


mean(result.ci1, dims=1)
mean(result.ci2, dims=1)
mean(result.ci3, dims=1)