using DataFrames
using SpeciesInteractionNetworks

function bmratio(
    species::Any,
    bodymass::Vector{Float64};
    α::Float64 = 1.41,
    β::Float64 = 3.73,
    γ::Float64 = 1.87)

    S = length(species)

    prob_matrix = zeros(AbstractFloat, (S, S))
    for i in 1:S
        for j in 1:S
            MR = bodymass[i]/bodymass[j]
            if MR == 0
                p = exp(α)
                else
                    p = exp(α + β*log(MR) + γ*log(MR)^2)
                end
                if p/(1-p) >= 0.0
                    prob_matrix[i,j] = p/(1-p)
                end
            end
        end

    # make probabanilistic
    prob_matrix = prob_matrix./maximum(prob_matrix)
    
    edges = Probabilistic(prob_matrix)
    nodes = Unipartite(Symbol.(species))
    return SpeciesInteractionNetwork(nodes, edges)    
end