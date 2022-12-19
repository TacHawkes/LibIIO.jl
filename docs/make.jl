using LibIIO
using LibIIO.CLibIIO
using Documenter

makedocs(;
    modules=[LibIIO],
    authors="Oliver Kliebisch <oliver@kliebisch.net> and contributors",
    repo="https://github.com/tachawkes/LibIIO.jl/blob/{commit}{path}#{line}",
    sitename="LibIIO.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md"
    ],
)

deploydocs(;
    repo="github.com/TacHawkes/LibIIO.jl.gi",
    devbranch="main",
)
