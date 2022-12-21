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
        "Home" => "index.md",
        "Examples" => [
            "IIO Demo" => "iio_demo.md"
        ],
        "High-level libiio bindings" => [
            "Context" => "context.md",
            "Devices" => "device.md",
            "Channel" => "channel.md",
            "Buffer" => "buffer.md",
        ],
        "Low-level libiio access (for advanced users)" => [
            "Overview" => "cindex.md",
            "Functions for scanning available contexts" => "cscan.md",
            "Top-level functions" => "ctoplevel.md",
            "Context" => "ccontext.md",
            "Device" => "cdevice.md",
            "Channel" => "cchannel.md",
            #"cbuffer.md",
            #"cdebug.md"
        ]
    ],
)

deploydocs(;
    repo="github.com/TacHawkes/LibIIO.jl.gi",
    devbranch="main",
)
