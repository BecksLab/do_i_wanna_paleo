using SpeciesInteractionNetworks
using StatsBase

"""
extinction(N::SpeciesInteractionNetwork{<:Partiteness,<:Binary}, end_richness::Int64)

    Function to simulate secondary extinctions using an initial network N unitl the richness is 
    less than or equal to that specified by `end_richness`.
"""

function extinction(N::SpeciesInteractionNetwork{<:Partiteness,<:Binary}, end_richness::Int64)
    if richness(N) <= end_richness
        throw(ArgumentError("Richness of final community is less than starting community"))
    end

    network_series = Vector{SpeciesInteractionNetwork{<:Partiteness,<:Binary}}(undef, richness(N)+1)
    network_series[1] = deepcopy(N)
    final_network = deepcopy(N)
    # order of species to remove
    extinction_sequence = StatsBase.shuffle(SpeciesInteractionNetworks.species(N))

    for (i, sp_to_remove) in enumerate(extinction_sequence)
            species_to_keep = filter(sp -> sp != sp_to_remove, SpeciesInteractionNetworks.species(network_series[i]))
            K = subgraph(N, species_to_keep)
            K = simplify(K)
            network_series[i+1] = K
        if richness(K) <= end_richness
            final_network = K
            break
        else
            continue
        end
    end
    return final_network
end