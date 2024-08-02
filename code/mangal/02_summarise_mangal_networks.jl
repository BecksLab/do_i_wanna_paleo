using CSV
using DataFrames
using JLD2
using Mangal
using ProgressMeter
using SpeciesInteractionNetworks

include("../lib/internals.jl")

mangal_foodwebs = CSV.read("data/raw/mangal/mangal_foodwebs_metadata.csv", DataFrame)

N_mangal = network.(mangal_foodwebs.id)