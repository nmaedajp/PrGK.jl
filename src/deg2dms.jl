# coded by chatGPT on 2025/09/02
function deg2dms(deg::Real; sec_digits::Integer=2)
    # 角度の符号（-0.0 は 0 と同じ扱い）
    sgn = (deg < 0) ? -1 : 1
    adeg = abs(float(deg))

    # 総秒に変換して丸め（桁指定）
    total_sec = round(adeg * 3600, digits=sec_digits)

    # 分解
    d = floor(Int, total_sec / 3600)
    rem_sec = total_sec - d * 3600
    m = floor(Int, rem_sec / 60)
    s = round(rem_sec - m * 60, digits=sec_digits)

    # 繰り上がり（丸めで 60 になる場合）
    if s >= 60.0 - 10.0^(-sec_digits) * 0.5
        s = 0.0
        m += 1
    end
    if m == 60
        m = 0
        d += 1
    end

    # 符号付け（最初の非ゼロへ）
    if deg != 0
        if d != 0
            d *= sgn
        elseif m != 0
            m *= sgn
        elseif s != 0
            s *= sgn
        end
    end

    return d, m, s
end
# function dms2deg(d, m, s; isg = 1)
#     if isg == 1
#         degrees = d + m/60.0 + s/3600.0
#     else
#         ad = abs(d)
#         degrees = - (ad + m/60.0 + s/3600.0)
#     end
#     return degrees
# end

deg = 0.125

d, m, s = deg2dms(deg)
@show d, m, s

deg = -0.125
d, m, s = deg2dms(deg)
@show d, m, s

# ## Example usage:
# d = 100
# m = 30
# s = 15

# @show dms2deg(d, m, s)
# deg = dms2deg(d, m, s)
# @show deg2dms(deg)

# d = -100
# m = 30
# s = 15

# @show dms2deg(d, m, s, isg = -1)
# deg2 = dms2deg(d, m, s)
# @show deg2dms(deg)

