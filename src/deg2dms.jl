function deg2dms(degrees)
    if degrees > 0
        d = floor(degrees)
        m = floor((degrees - d) * 60)
        s = (degrees - d - m / 60) * 3600
    else
        adeg = abs(degrees)
        d = floor(adeg)
        m = floor((adeg - d) * 60)
        s = (adeg - d - m / 60) * 3600
        d = -d
    end
    return d, m, s
end
function dms2deg(d, m, s)
    if d >= 0
        degrees = d + m/60.0 + s/3600.0
    else
        ad = abs(d)
        degrees = - (ad + m/60.0 + s/3600.0)
    end
    return degrees
end

## Example usage:
# d = 100
# m = 30
# s = 15

# @show dms2deg(d, m, s)
# deg = dms2deg(d, m, s)
# @show deg2dms(deg)

# d = -100
# m = 30
# s = 15

# @show dms2deg(d, m, s)
# deg = dms2deg(d, m, s)
# @show deg2dms(deg)
