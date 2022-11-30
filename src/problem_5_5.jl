using Plots, Statistics, Distributions

Z = Normal()
W = Normal()

mvnorm = fit(MvNormal, [rand(0.0:100.0, 100) rand(0.0:100.0, 100)]')

plotZ = [pdf(mvnorm,[i,j]) for i in 0:100, j in 0:100]
plot(0:100, 0:100, plotZ, st=:surface)