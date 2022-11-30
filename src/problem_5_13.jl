using Statistics, Plots, Distributions, Random

Random.seed!(12481592)

Y = Cauchy()
Z = Normal()

function simulation_cauchy(n, reps)
    out = zeros(reps)
    for i in 1:reps
        drawY = rand(Y, n)
        drawZ = rand(Z, n)
        draw = drawY .* drawZ

        out[i] = mean(draw)
    end
    return out
end
n_values = [10, 100, 500, 1000, 2500, 5000, 10000]

results = [simulation_cauchy(i, 10000) for i in n_values]

means = mean.(results)
vars = var.(results)
sds = sqrt.(vars)

plot(n_values, means, label = "Mean")
plot(n_values, sds, label = "Standard Deviation")