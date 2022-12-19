using LibIIO
using LibIIO.CLibIIO
using Documenter

DocMeta.setdocmeta!(LibIIO, :DocTestSetup, :(using LibIIO); recursive=true)

makedocs(;
    modules=[LibIIO],
    authors="Oliver Kliebisch <oliver@kliebisch.net> and contributors",
    repo="https://github.com/TacHawkes/LibIIO.jl/blob/{commit}{path}#{line}",
    sitename="LibIIO.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tachawkes.net.github.io/LibIIO.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Low-level C-API" => "capi.md"
    ],
)

deploydocs(;
    repo="github.com/tachawkes/LibIIO.jl",
    devbranch="main",
)
