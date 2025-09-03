# PrGK

国土地理院の式により，平面直角座標と緯度経度 間の変換を行うための関数 と 作業した際に用いた関数をまとめた．

## 平面直角座標と緯度経度の変換
### 国土地理院の式
* 変換の式を示しているページ
  * [緯度・経度から平面直角座標](https://vldb.gsi.go.jp/sokuchi/surveycalc/surveycalc/algorithm/bl2xy/bl2xy.htm)：緯度・経度から，平面直角座標$X$，$Y$から，緯度，経度，子午線収差角，縮尺係数を求める．
  * [平面直角座標から緯度・経度](https://vldb.gsi.go.jp/sokuchi/surveycalc/surveycalc/algorithm/xy2bl/xy2bl.htm) ：平面直角座標$X$，$Y$から，緯度，経度，子午線収差角，縮尺係数を求める．

### 平面直角座標の説明
* [国土地理院内のページ](https://www.gsi.go.jp/sokuchikijun/jpc.html) ：北向きに$X$，東向きに$Y$ を取ることに注意．

### bl2xy(alat, alng, alat0, alng0; a = 6378137.0, F = 298.257222101, m0 = 0.9999)
* 引数
  * alat，alng：平面直角座標に変換したい点の緯度・経度
  * alat0, alng0：原点座標の緯度・経度．IX系原点の場合は，alat0 = 36度, along0 = 139度50分．
* キーワード引数
  * a：地球楕円体の長半径：6378137.0 [m]
  * F：地球楕円体の扁平率の逆数：298.257222101
    * a，F は測地基準系1980 の値
  * m0：平面直角座標系の$X$軸上における縮尺係数：0.9999
* 戻り値
  * x, y, γ, m：平面直角座標の x, y，子午線収差角，縮尺係数
    * x，y はそれぞれ 北方向，東方向．単位は m．通常のグラフの軸とは違うので注意が必要
    * 子午線収差角は，真北から見た地図の北（座標のx軸の正）の方向の角度．単位は度．
  * Tupple で返ってくる．
 
### xy2bl(x, y, alat0, alng0; a = 6378137.0, F = 298.257222101, m0 = 0.9999)
* 引数
  * `x`，`y`：緯度・経度に変換したい点の平面直角座標の値．単位は m．
  * `alat0`, `alng0`：原点座標の緯度・経度．IX系原点の場合は，`alat0` = 36度, `along0` = 139度50分．
* キーワード引数
  * `a`：地球楕円体の長半径：6378137.0 [m]
  * `F`：地球楕円体の扁平率の逆数：298.257222101
    * `a`，`F` は測地基準系1980 の値
  * `m0`：平面直角座標系の$X$軸上における縮尺係数：0.9999
* 戻り値
  * `alat`, `along`, `γ`, `m`：緯度，経度，子午線収差角，縮尺係数
    * 緯度・経度の単位は度．
    * 子午線収差角は，真北から見た地図の北（座標のx軸の正）の方向の角度．単位は度．
  * Tupple で返ってくる．

## その他の関数
### deg2dms(deg::Real; sec_digits::Integer=2)
* 私が作成したソースをもとに chatGPT により作成した．
* 以下は，chatGPT による解説をもとに作成．
  * 小数の度 `deg` を (度, 分, 秒) に変換する．
  * 符号は「度→分→秒」の順で最初の非ゼロ要素にだけ付与する。
  * `sec_digits` は秒の小数桁数（既定 2）。
  * 戻り値: (Int, Int, Real)

### dms2deg(d::Real, m::Real, s::Real)
* 度(d), 分(m), 秒(s) から小数度 (Float64) に変換します。
  * 符号は d, m, s のうち最初に非ゼロとなる値から継承します。
  * 入力は整数度・整数分・実数秒を想定しています。
  * 戻り値: Float64 （小数度）

### rot2d(x, y, theta; deg=true, about=(0.0, 0.0), convention=:axes)
* chatGPTによるコード
* 2次元点 (x, y) の座標を回転変換して返す．
* 引数
  * `x::Real`，`y::Real` ： 2次元の点(x, y)．
    * ここでは，通常の数学的座標軸のイメージで記述されている．
    * 反時計回りといった表現．
* キーワード引数
  * `theta::Real` : 回転角．`deg=true` なら度，`deg=false` ならラジアン．
  * `deg::Bool=true` : 角度がラジアンなら `false`．初期設定を度としている．
  * `about::Tuple{<:Real,<:Real}=(0.0, 0.0)` : 回転中心 (cx, cy)．
  * `convention::Symbol=:axes` :
    * `:axes` ：座標軸を θ だけ反時計回りに回す．同一点の新座標を返す．
    * `:point`：点を θ だけ反時計回りに回す．
* 戻り値
  * `(xnew, ynew)` のタプル（Float64）
* 備考
  * 軸の回転は点の回転と角度符号が逆になる（`θ_axes = -θ_point`）．

### point_in_polygon_ray(x::AbstractVector, xb::AbstractMatrix; tol = 1e-12)
* chatGPTによる作成
* 引数
  * x：内部外部判定を行いたい点．x座標，y座標のベクトルとなっている．x = [x, y]
  * xb：境界の座標．[x1 y1; x2 y2; ... xn yn] のような n行2列 の行列となっている．
* キーワード引数
  * tol=1e-12：ゼロとみなす許容範囲．
* 戻り値
  * :inside，:outside，:boundary：それぞれ，内部，外部，境界上にあるときの戻り値

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://nmaedajp.github.io/PrGK.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://nmaedajp.github.io/PrGK.jl/dev/)
[![Build Status](https://github.com/nmaedajp/PrGK.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/nmaedajp/PrGK.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/nmaedajp/PrGK.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/nmaedajp/PrGK.jl)
