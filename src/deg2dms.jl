# coded by chatGPT on 2025/09/02
# """
#     deg2dms(deg; sec_digits=3)
# 小数度 `deg` を (度, 分, 秒) に変換します。
# 符号は「度→分→秒」の順で最初の非ゼロ要素にだけ付与します。
# `sec_digits` は秒の小数桁数（既定 3）。
# 戻り値: (Int, Int, Real)
# """
function deg2dms(deg::Real; sec_digits::Integer=3)
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
# """
#     dms2deg(d, m, s)
# 度(d), 分(m), 秒(s) から小数度 (Float64) に変換します。
# - 符号は d, m, s のうち最初に非ゼロとなる値から継承します。
# - 入力は整数度・整数分・実数秒を想定しています。
# 戻り値: Float64 （小数度）
# """
function dms2deg(d::Real, m::Real, s::Real)
    # 符号は最初の非ゼロから
    if d != 0
        sgn = sign(d)
    elseif m != 0
        sgn = sign(m)
    elseif s != 0
        sgn = sign(s)
    else
        return 0.0
    end

    adeg = abs(float(d)) + abs(float(m))/60 + abs(float(s))/3600
    return sgn * adeg
end