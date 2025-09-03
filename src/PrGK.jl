module PrGK

export bl2xy, xy2bl, deg2dms, dms2deg, point_in_polygon_ray, rot2d

# Gauss-Krüger projection using GSI (Geospatial Information Authority of Japan) formula
# https://vldb.gsi.go.jp/sokuchi/surveycalc/surveycalc/algorithm/bl2xy/bl2xy.htm
# https://vldb.gsi.go.jp/sokuchi/surveycalc/surveycalc/algorithm/xy2bl/xy2bl.htm

include("bl2xy.jl")
include("xy2bl.jl")
include("deg2dms.jl")
include("inout.jl")
include("rotation2d.jl")

end
