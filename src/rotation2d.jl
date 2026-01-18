# coded by chatGPT on 2025/09/02
# """
#     rot2d(x, y, theta; deg=true, about=(0.0, 0.0), convention=:axes)

# 2次元点 (x, y) の座標を回転変換して返します。

# # キーワード引数
# - `theta::Real` : 回転角。`deg=false` ならラジアン、`deg=true` なら度。
# - `deg::Bool=true` : 角度がラジアンなら `false`。
# - `about::Tuple{<:Real,<:Real}=(0.0, 0.0)` : 回転中心 (cx, cy)。
# - `convention::Symbol=:axes` :
#     - `:axes`  … 座標軸を θ だけ反時計回りに回す（受動変換）。同一点の新座標を返す。
#     - `:point` … 点を θ だけ反時計回りに回す（能動変換）。

# # 戻り値
# - `(xnew, ynew)` のタプル（Float64）

# # 備考
# - 受動変換（軸の回転）は能動変換の角度符号が逆になります（`θ_axes = -θ_point`）。
# """
function rot2d(x::Real, y::Real, theta::Real;
                  deg::Bool=true, center::Tuple{<:Real,<:Real}=(0.0, 0.0),
                  convention::Symbol=:axes)

    θ = deg ? theta * (π/180) : theta

    ang = convention === :axes  ? -θ :
          convention === :point ?  θ :
          throw(ArgumentError("convention must be :axes or :point"))

    cx, cy = center
    X = x - cx
    Y = y - cy

    c = cos(ang); s = sin(ang)
    xnew =  c*X - s*Y 
    ynew =  s*X + c*Y 
    return xnew, ynew
end

# # 例1: 座標軸を +90° 回転（受動変換）
# ex1 = rot2d(1.0, 0.0, 90, deg=true, convention=:axes)
# @show ex1
# # → (0.0, -1.0) 付近

# # 例2: 点を +90° 回転（能動変換）
# ex2 = rot2d(1.0, 0.0, 90, deg=true, convention=:point)
# @show ex2
# # → (0.0, 1.0) 付近

# # 例3: 原点ではなく (2,3) を中心に点を 30° 回転
# ex3 = rot2d(4.0, 3.0, 30, deg=true, center=(2.0, 3.0), convention=:point)
# @show ex3
# # → (3.732..., 4.0) 付近

# xs = [1,2,3]; ys = [0,1,1]
# rotated = rot2d.(xs, ys, 15, deg=true, convention=:axes)

# for i = 1:3
#       @show xs[i], ys[i], rotated[i][1], rotated[i][2]
# end
