using Plots, Statistics, Distributions

function sumseq(x)
    out = zeros(length(x))
    for i in eachindex(x)
        out[i] = sum(sqrt.(x[1:i]))
    end
    return out
end

seq = Vector(1:100000)
numer = sumseq(seq)
denom = seq.^1
ratio = numer ./ denom
plot(numer, label = "Numerator")
plot!(denom, label = "Denominator")
plot!(ratio, label = "Ratio")

plot(ratio)

# Simulate (a)
dist_X(i) = Normal(0, sqrt(sqrt(i)))

function draw_sample(n)
    draw = zeros(n)
    for i in 1:n
        draw[i] = rand(dist_X(i))
    end
    return draw
end

function compute_xbar(sample)
    out = similar(sample)
    for i in eachindex(sample)
        out[i] = mean(sample[1:i])
    end
    return out
end

n = 10000
sample = draw_sample(n)
xbar = compute_xbar(sample)
plot(xbar, label = "Sample Mean")

reps = 1000

samples = Matrix(undef, reps, n)
xbars = similar(samples)

function simulate(reps, n)
    xbars = Matrix(undef, reps, n)
    for i in 1:reps
        sample = draw_sample(n)
        xbars[i, :] = compute_xbar(sample)
    end

    return xbars
end

xbars = simulate(1000, 5000)
means = vec(mean(xbars, dims=1))

plot(means)
