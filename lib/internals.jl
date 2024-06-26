# General sundry internal functions

"""
_get_matrix(N::SpeciesInteractionNetwork{<:Partiteness, <:Binary})

    Internal function to return a matrix of interactions from a
    SpeciesInteractionNetwork
"""
function _get_matrix(N::SpeciesInteractionNetwork{<:Partiteness,<:Binary})

    species = richness(N)
    n = zeros(Int64, (species, species))
    for i in axes(n, 1)
        for j in axes(n, 2)
            if N.edges[i, j] == true
                n[i, j] = 1
            end
        end
    end

    return n
end

"""
_network_summary(N::SpeciesInteractionNetwork{<:Partiteness, <:Binary})

    returns the 'summary statistics' for a network
"""
function _network_summary(N::SpeciesInteractionNetwork{<:Partiteness,<:Binary})

    A = _get_matrix(N)

    gen = SpeciesInteractionNetworks.generality(N)
    ind_maxgen = findmax(collect(values(gen)))[2]

    D = Dict{Symbol,Any}(
        :richness => richness(N),
        :links => links(N),
        :connectance => connectance(N),
        :complexity => complexity(N),
        :distance => distancetobase(N, collect(keys(gen))[ind_maxgen]),
        :basal => sum(vec(sum(A, dims = 2) .== 0)),
        :top => sum(vec(sum(A, dims = 1) .== 0)),
        :S1 => length(findmotif(motifs(Unipartite, 3)[1], N)),
        :S2 => length(findmotif(motifs(Unipartite, 3)[2], N)),
        :S4 => length(findmotif(motifs(Unipartite, 3)[4], N)),
        :S5 => length(findmotif(motifs(Unipartite, 3)[5], N)),
    )

    return D
end

"""
model_summary(N::SpeciesInteractionNetwork{<:Partiteness, <:Binary})

    returns the 'summary statistics' for a network (D) as well as the
    predicted network (N).
"""
function model_summary(
    df::DataFrame,
    community_id::Any,
    model_name::String;
    bodymass::Vector{Float64} = [0.0, 0.0],
)

    # data checks
    if model_name ∉ ["bodymassratio", "pfim"]
        error(
            "Invalid value for model_name -- must be one of bodymassratio, pfim",
        )
    end
    if model_name == "bodymassratio" && length(bodymass) != length(df.species)
        error("Invalid length for bodymass -- must be length $(length(df.species))")
    end

    # generate network based on specified model
    if model_name == "bodymassratio"
        N = bmratio(df.species, bodymass)
        N = randomdraws(N) # from probabalistic to binary
    elseif model_name == "pfim"
        N = PFIM(df)
        N = randomdraws(N) # from probabalistic to binary

        d = _network_summary(N)
        D = Dict{Symbol,Any}()
        D[:id] = community_id
        D[:model] = model_name
        D[:connectance] = d[:connectance]
        D[:complexity] = d[:complexity]
        D[:distance] = d[:distance]
        D[:basal] = d[:basal]
        D[:top] = d[:top]
        D[:S1] = d[:S1]
        D[:S2] = d[:S2]
        D[:S4] = d[:S4]
        D[:S5] = d[:S5]
    end
    return D
end