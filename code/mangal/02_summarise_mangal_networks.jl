using CSV
using DataFrames
using JLD2
using Mangal
using ProgressMeter
using SpeciesInteractionNetworks

include("../../lib/internals.jl")

mangal_foodwebs = CSV.read("data/raw/mangal/mangal_foodwebs_metadata.csv", DataFrame)

N_mangal = network.(mangal_foodwebs.id)

# make a dataframe to store network data
mangal_topology = DataFrame(
    id = Int64[],
    richness = Int64[],
    links = Int64[],
    connectance = Float64[],
    complexity = Float64[],
    distance = Float64[],
    basal = Float64[],
    top = Float64[],
    S1 = Float64[],
    S2 = Float64[],
    S4 = Float64[],
    S5 = Float64[],
);

# get summary stats
for i in 1:nrow(mangal_foodwebs)

    N = simplify(mangalnetwork(mangal_foodwebs.id[i]))
    N = render(Binary, N) # make binary

    d = _network_summary(N)

    D = Dict{Symbol,Any}()
        D[:id] = mangal_foodwebs.id[i]
        D[:richness] = d[:richness]
        D[:links] = d[:links]
        D[:connectance] = d[:connectance]
        D[:complexity] = d[:complexity]
        D[:distance] = d[:distance]
        D[:basal] = d[:basal]
        D[:top] = d[:top]
        D[:S1] = d[:S1]
        D[:S2] = d[:S2]
        D[:S4] = d[:S4]
        D[:S5] = d[:S5]
        push!(mangal_topology, D)
    
end

CSV.write("data/processed/mangal_summary.csv", mangal_topology)

