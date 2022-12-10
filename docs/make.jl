using LibIIO
using Documenter

DocMeta.setdocmeta!(LibIIO, :DocTestSetup, :(using LibIIO); recursive=true)

makedocs(;
    modules=[LibIIO],
    authors="Oliver Kliebisch <oliver@kliebisch.net> and contributors",
    repo="https://github.com/oliver@kliebisch.net/LibIIO.jl/blob/{commit}{path}#{line}",
    sitename="LibIIO.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://oliver@kliebisch.net.github.io/LibIIO.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/oliver@kliebisch.net/LibIIO.jl",
    devbranch="main",
)
