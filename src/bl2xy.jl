function bl2xy(alat, alng, alat0, alng0)
# 度からラジアン
    phi = deg2rad(alat)
    lam = deg2rad(alng)
    lam0 = deg2rad(alng0)
    phi0 = deg2rad(alat0)
# 定数の定義
    a = 6_378_137 # 長半径［m］
    F = 298.257222101 # 扁平率の逆数
    m0 = 0.9999 # 中央子午線の縮尺係数
# 諸量の計算
    n = 1/(2*F-1) # 第3扁平率
    t = sinh(atanh(sin(phi)) - 2*sqrt(n)/(1+n)*atanh(2*sqrt(n)/(1+n)*sin(phi))) 
    tbar = sqrt(1 + t^2)
    lamc = cos(lam - lam0) ; lams = sin(lam - lam0) ;
    xip = atan(t / lamc) ; etap = atanh(lams/tbar) ; 
    alpha = [
        n/2-(2/3)*n^2+(5/16)*n^3 + (41/180)*n^4-(127/288)*n^5
        (13/48)*n^2 - (3/5)*n^3 + (557/1440)*n^4 + (281/630)*n^5
        (61/240)*n^3 - (103/140)*n^4 + (15061/26880)*n^5
        (49561/161280)*n^4 - (179/168)*n^5
        (34729/80640)*n^5
    ]
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

    sjx = [sin(2*j*xip) for j = 1:5]
    cjx = [cos(2*j*xip) for j = 1:5]
    shje = [sinh(2*j*etap) for j = 1:5]
    chje = [cosh(2*j*etap) for j = 1:5]
    j2 = [2*j for j = 1:5]
    sig = 1 + sum(j2 .* alpha .* cjx .* chje)
    tau = sum(j2 .* alpha .* sjx .* shje)
    x = Abar * (xip + sum(alpha .* sjx .* chje)) - Sphi0
    y = Abar * (etap + sum(alpha .* cjx .* shje))
    γ = atan((tau*tbar*lamc + sig*t*lams)/(sig*tbar*lamc - tau*t*lams))
    m = (Abar/a) * sqrt((sig^2 + tau^2)/(t^2 + lamc^2)*(1 + ((1-n)/(1+n) * tan(phi))^2))
    return x, y, rad2deg(γ), m
end

## Test cases
# alat0 = 36.0; along0 = 139.0 + 50.0/60.0  # IX th reference point
# alat = [35.0 + 17.5/60.0, 35.0 + 17.5/60.0, 35.0 + 20.0/60.0, 35.0 + 20.0/60.0]
# along = [139.0 + 37.5/60.0,  139.0 + 41.25/60.0, 139.0 + 37.5/60.0, 139.0 + 41.25/60.0]
# for i = 1:4
#     x, y, γ, m = bl2xy(alat[i], along[i], alat0, along0)
#     @show deg2dms(alat[i]), deg2dms(along[i]), x, y, deg2dms(γ), m
# end
