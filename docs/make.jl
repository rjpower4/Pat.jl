using Documenter
using Pat

makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true"
    ),
    modules = [Pat],
    sitename = "Pat.jl",
    authors = "Rolfe Power",
    linkcheck = !("skiplinks" in ARGS),
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo="github.com/rjpower4/Pat.jl.git",
    devbranch="main",
)