using CSV
using DataFrames

include("../lib/extinctions.jl")

# create trait dataframe
# get the name of all communities
matrix_names = readdir(joinpath("data", "clean", "trait"))
matrix_names = replace.(matrix_names, ".csv" => "")

traits = DataFrame(
    species = Any[],
    feeding = Any[],
    motility = Any[],
    tiering = Any[],
    size = Any[],
)

for i in eachindex(matrix_names)    
    file_name = matrix_names[i]
    df = DataFrame(
        CSV.File.(
            joinpath("data", "clean", "trait", "$file_name.csv"),
        ),
    )
    append!(traits, df)
end

traits = unique(traits)

