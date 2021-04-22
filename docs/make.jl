using Documenter
using FeatureDescriptors

makedocs(;
    modules=[FeatureDescriptors],
    authors="Invenia Technical Computing Corporation",
    repo="https://github.com/invenia/FeatureDescriptors.jl/blob/{commit}{path}#L{line}",
    sitename="FeatureDescriptors.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://invenia.github.io/FeatureDescriptors.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    checkdocs=:exports,
    strict=true,
)

deploydocs(;
    repo="github.com/invenia/FeatureDescriptors.jl",
    devbranch = "main",
    push_preview = true,
)
