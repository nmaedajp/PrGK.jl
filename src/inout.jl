# 2次元外積
cross2(a, b) = a[1]*b[2] - a[2]*b[1]

# 境界上かどうかの確認
function on_segment(a::AbstractVector, b::AbstractVector, p::AbstractVector; tol=1e-12)
    ab = b .- a; nrab = sqrt(ab[1]^2+ab[2]^2)
    ap = p .- a; nrap = sqrt(ap[1]^2+ap[2]^2)
    # 1) ほぼ一直線（外積 ~ 0）
    if abs(cross2(ab, ap)) > tol*max(1.0, nrab*nrap); return false; end
    # 2) 端点間の矩形内か
    if !(minimum((a[1], b[1])) - tol <= p[1] <= maximum((a[1], b[1])) + tol); return false; end
    if !(minimum((a[2], b[2])) - tol <= p[2] <= maximum((a[2], b[2])) + tol); return false; end
    return true
end

# 内部かどうかの確認
function point_in_polygon_ray(x::AbstractVector, xb::AbstractMatrix; tol=1e-12)
    n = size(xb, 1)
    inside = false
    prev = view(xb, n, :)
    for i in 1:n
        cur = view(xb, i, :)
        # 境界上チェック
        if on_segment(prev, cur, x; tol=tol)
            return :boundary
        end
        yi, yj = prev[2], cur[2]
        xi, xj = prev[1], cur[1]
        # 半開区間でのY方向の跨ぎ判定
        if (yi > x[2]) != (yj > x[2])
            # 交点のx座標
            xint = xi + (x[2] - yi) * (xj - xi) / (yj - yi)
            if xint > x[1] + tol
                inside = !inside
            end
        end
        prev = cur
    end
    return inside ? :inside : :outside
end
