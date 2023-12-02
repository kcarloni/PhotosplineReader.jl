using Documenter, PhotosplineReader

makedocs(;
    modules=[PhotosplineReader],
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        assets=String[],
    ),
    pages=[
        "APIs" => "internalapis.md",
    ],
    sitename="PhotosplineReader.jl",
    authors="all contributors",
)

deploydocs(;
    repo="github.com/kcarloni/PhotosplineReader.jl",
    push_preview=true
)
