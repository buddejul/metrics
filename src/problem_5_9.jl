using Plots, Statistics, Distributions

θ = 2
expo = Exponential(θ)

θ_1(x) = mean(x)
θ_2(x) = sqrt(0.5 * length(x)^-1 * sum(x.^2))

n = 1000
reps = 10000

function simulation(θ, n, reps)
    expo = Exponential(θ)
    out = zeros(reps, 2)

    for i in 1:reps
        draw = rand(expo, n)
        out[i, 1] = θ_1(draw)
        out[i, 2] = θ_2(draw)
    end

    return out
end

results = simulation(10, 10000, 10000)

histogram(results[:,1], label = "Sample Mean")
histogram!(results[:,2], label = "Alternative Estimator")
