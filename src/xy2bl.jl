function xy2bl(x, y, alat0, alng0; a = 6378137.0, F = 298.257222101, m0 = 0.9999)
# 度からラジアン
    lam0 = deg2rad(alng0)
    phi0 = deg2rad(alat0)
# 定数の定義
#     a = 6_378_137 # 長半径［m］
#     F = 298.257222101 # 扁平率の逆数
#     m0 = 0.9999 # 中央子午線の縮尺係数
# 諸量の計算
    n = 1/(2*F-1) # 第3扁平率
    A0 = 1 + (1/4)*n^2 + (1/64)*n^4
    Abar = A0 * (m0 * a)/(1 + n)
    A = [
        -(3/2)*n + (3/16)*n^3 + (3/128)*n^5
         (15/16)*n^2 - (15/64)*n^4
        -(35/48)*n^3 + (175/768)*n^5
         (315/512)*n^4
        -(693/1280)*n^5
    ]
    sj = [sin(2*j*phi0) for j = 1:5]
    Sphi0 = Abar * phi0 + sum(A .* sj) * (m0 * a)/(1 + n)

    xi = (x + Sphi0) / Abar; eta = y / Abar

    sjx = [sin(2*j*xi) for j = 1:5]
    cjx = [cos(2*j*xi) for j = 1:5]
    shje = [sinh(2*j*eta) for j = 1:5]
    chje = [cosh(2*j*eta) for j = 1:5]
    j2 = [2*j for j = 1:5]

    beta = [
            (1/2)*n-(2/3)*n^2+(37/96)*n^3-(1/360)*n^4-(81/512)*n^5
            (1/48)*n^2+(1/15)*n^3-(437/1440)*n^4+(46/105)*n^5
            (17/480)*n^3-(37/840)*n^4-(209/4480)*n^5
            (4397/161280)*n^4-(11/504)*n^5
            (4583/161280)*n^5
        ]
    xip = xi - sum(beta .* sjx .* chje)
    etap = eta - sum(beta .* cjx .* shje)
    sigp = 1 - sum(j2 .* beta .* cjx .* chje)
    taup = sum(j2 .* beta .* sjx .* shje)

    delta = [
        -(2/3)*n^2-(2/3)*n^3+(4/9)*n^4+(2/9)*n^5
         (1/3)*n^2-(4/15)*n^3-(23/45)*n^4+(68/45)*n^5
         (2/5)*n^3-(24/35)*n^4-(46/35)*n^5
         (83/126)*n^4-(80/63)*n^5
         (52/45)*n^5
        ]

    chi = asin(sin(xip)/cosh(etap))
    sjchi = [sin(2*j*chi) for j = 1:5]
    tpsi = (1+n)/(1-n) * tan(chi + sum(delta .* sjchi))

    phi = atan((1+n)/(1-n) * tpsi)
    phi_deg = rad2deg(phi)
    lam = lam0 + atan(sinh(etap) / cos(xip))
    lam_deg = rad2deg(lam)
    γ = atan((taup + sigp * tan(xip) * tanh(etap)), (sigp - taup * tan(xip) * tanh(etap)))
    γ_deg = rad2deg(γ)
    m = (Abar/a) * sqrt((cos(xip)^2 + sinh(etap)^2)/(sigp^2 + taup^2) * (1 + tpsi^2))

    return phi_deg, lam_deg, γ_deg, m
end

## Test cases
# alat0 = 36.0; along0 = 139.0 + 50.0/60.0  # IX th reference point
# x = [
#   -78563.5591  -18948.7564
#   -78573.7097  -13264.1245
#   -73941.2483  -18939.0412
#   -73951.4041  -13257.3238
#  ]
# for i = 1:4
#     alat, along, γ, m = xy2bl(x[i, 1], x[i, 2], alat0, along0)
#     @show round(alat, digits=7), round(along, digits=7), x[i, 1], x[i, 2], round(γ, digits=8), round(m, digits=8)
# end
