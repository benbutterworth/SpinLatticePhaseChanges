using SpinLatticePhaseChanges
using Documenter

DocMeta.setdocmeta!(SpinLatticePhaseChanges, :DocTestSetup, :(using SpinLatticePhaseChanges); recursive=true)

makedocs(;
    modules=[SpinLatticePhaseChanges],
    authors="benbutterworth <127899580+benbutterworth@users.noreply.github.com> and contributors",
    sitename="SpinLatticePhaseChanges.jl",
    format=Documenter.HTML(;
        canonical="https://ben.github.io/SpinLatticePhaseChanges.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ben/SpinLatticePhaseChanges.jl",
    devbranch="master",
)
