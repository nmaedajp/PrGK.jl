using PrGK
using Documenter

DocMeta.setdocmeta!(PrGK, :DocTestSetup, :(using PrGK); recursive=true)

makedocs(;
    modules=[PrGK],
    authors="Naoki Maeda <fnkyksj@gmail.com> and contributors",
    sitename="PrGK.jl",
    format=Documenter.HTML(;
        canonical="https://nmaedajp.github.io/PrGK.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/nmaedajp/PrGK.jl",
    devbranch="main",
)
