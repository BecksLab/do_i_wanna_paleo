using CSV
using DataFrames
using JLD2
using Mangal
using ProgressMeter
using SpeciesInteractionNetworks

# This script has been ported and (minimally) modified from github user
# @FransisBanville, the original source code can be found here:
# https://github.com/FrancisBanville/ms_maxent_networks/blob/master/code/01_import_mangal_metadata.jl

# query the ID number and other metadata for all ecological networks archived on mangal.io

number_of_networks = count(MangalNetwork)
count_per_page = 100
number_of_pages = convert(Int, ceil(number_of_networks/count_per_page))

mangal_networks = DataFrame(
    id = Int64[],
    species = Int64[],
    links = Int64[],
    predators = Int64[],
    herbivores = Int64[],
    latitude = Any[],
    longitude = Any[],
    );

@showprogress "Paging networks" for page in 1:number_of_pages
    networks_in_page = Mangal.networks("count" => count_per_page, "page" => page-1)
    @showprogress "Counting items" for current_network in networks_in_page
        D = Dict{Symbol,Any}()
        D[:id] = current_network.id
        D[:species] = count(MangalNode, current_network)
        D[:links] = count(MangalInteraction, current_network)
        D[:predators] = count(MangalInteraction, current_network, "type" => "predation")
        D[:herbivores] = count(MangalInteraction, current_network, "type" => "herbivory")
        if ismissing(current_network.position)
            D[:latitude] = string("NA")
            D[:longitude] = string("NA")
        else
            D[:latitude] = current_network.position[1]
            D[:longitude] = current_network.position[2]
        end
        push!(mangal_networks, D)
    end
end


## Filter for food webs (i.e. networks containing ONLY trophic links)
fw = (mangal_networks.predators .+ mangal_networks.herbivores) ./ mangal_networks.links .== 1
mangal_foodwebs = mangal_networks[fw, :]


## Write file
CSV.write("data/raw/mangal/mangal_foodwebs_metadata.csv", mangal_foodwebs)