using Distributions, StatsFuns

function condcdf(F, x::Real, a::Real, b::Real)

    if (x < a) condcdf_x = 0.0
    elseif (x > b) condcdf_x = 1.0
    else
        condcdf_x = (F(x) - F(a)) / (F(b) - F(a))
    end

    return condcdf_x
    
end

condcdf(normcdf, 0, -100, 100)