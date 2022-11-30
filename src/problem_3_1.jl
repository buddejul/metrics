using Random, Distributions, Plots

Random.seed!(123)

d = Normal()
mean(d)

smpl = rand(d, 1000)

histogram(smpl)

quantile.(Normal(), [0.5, 0.9, 0.95, 0.975])
cdf.(Normal(), 1.96)
pdf.(Normal(), 1.96)

fieldnames(Normal)
fit(Normal, smpl)
mean(smpl)

# Create own sampler for distribution from 3.1
# idea for sampling: generate uniform draws, then plug them into inverse of CDF
# how does this work with multivariate distributions?
# check implementation here: https://stackoverflow.com/questions/68796221/how-can-i-write-an-arbitrary-continuous-distribution-in-julia-or-at-least-simul
# need pdf and inverse CDF
# https://discourse.julialang.org/t/new-distribution-stack-overflow/77128/2
# Base.length(s::Spl) = ... # return the length of each sample

# function _rand!(rng::AbstractRNG, s::Spl, x::AbstractVector{T}) where T<:Real
#     # ... generate a single vector sample to x
# end