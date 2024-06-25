using DataFrames
using SpeciesInteractionNetworks

include(joinpath("rules.jl"))

mutable struct PFIMspecies
    species::Symbol
    feeding_trait::feeding
    size_trait::sizes
    motility_trait::motility
    tiering_trait::tier
end

# create community with appropraite types
function _pfim_community(data::DataFrame)


    PFIMcommunity = Array{PFIMspecies,1}(undef, nrow(data))

    for i in eachindex(PFIMcommunity)
        _PFIMsp = PFIMspecies(
            Symbol(data.species[i]),
            getfield(Main, Symbol(data.feeding[i]))(),
            getfield(Main, Symbol(data.size[i]))(),
            getfield(Main, Symbol(data.motility[i]))(),
            getfield(Main, Symbol(data.tiering[i]))(),
        )
        PFIMcommunity[i] = _PFIMsp
    end
    return PFIMcommunity
end

# determine link feasibility
function _pfim_link(consumer::PFIMspecies, resource::PFIMspecies)

    trait_sum =
        feeding_rules(consumer.feeding_trait, resource.feeding_trait) +
        motility_rules(consumer.motility_trait, resource.motility_trait) +
        tiering_rules(consumer.tiering_trait, resource.tiering_trait) +
        size_rules(consumer.size_trait, resource.size_trait)

    if trait_sum == 4
        link = 1
    else
        link = 0
    end
    return link
end

# construct network
function _PFIM_network(PFIMcommunity::Vector{PFIMspecies})

    S = length(PFIMcommunity)
    int_matrix = zeros(Bool, (S, S))

    for i in eachindex(PFIMcommunity)
        for j in eachindex(PFIMcommunity)
            int_matrix[i, j] = _pfim_link(PFIMcommunity[i], PFIMcommunity[j])
        end
    end

    nodes = Unipartite(getproperty.(PFIMcommunity, :species))
    edges = Binary(int_matrix)
    network = SpeciesInteractionNetwork(nodes, edges)
    return network, int_matrix
end

# downsample

function PFIM(data::DataFrame; y::Float64 = 2.5)

    S = nrow(data)
    PFIMcommunity = _pfim_community(data)
    network, matrix = _PFIM_network(PFIMcommunity)
    link_dist = zeros(Float64, S)

    # get link distribution
    for i in eachindex(data.species)
        sp = data.species[i]
        r = generality(network, Symbol(sp))
        E = exp(log(S) * (y - 1) / y)
        link_dist[i] = exp(r / E)
    end

    # create probabilistic int matrix
    prob_matrix = zeros(AbstractFloat, (S, S))
    for i in axes(matrix, 1)
        for j in axes(matrix, 2)
            if matrix[i, j] == true
                prob_matrix[i, j] = link_dist[i]
            end
        end
    end

    # make probabanilistic
    prob_matrix = prob_matrix ./ maximum(prob_matrix)

    edges = Probabilistic(prob_matrix)
    nodes = Unipartite(Symbol.(data.species))
    return SpeciesInteractionNetwork(nodes, edges)
end
