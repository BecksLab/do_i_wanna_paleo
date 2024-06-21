include(joinpath("rules.jl"))

mutable struct PFIMspecies
    feeding_trait::feeding
    size::Float64
    motility_trait::motility
    tiering_trait::tier
end

sp1 = PFIMspecies(
    predator(),
    21.0,
    motile_fast(),
    semi_aquatic()
    )

function _pfim_link(consumer::PFIMspecies, resource::PFIMspecies)

    trait_sum = feeding_rules(consumer.feeding_trait, resource.feeding_trait) + 
        motility_rules(consumer.motility_trait, resource.motility_trait) + 
        tiering_rules(consumer.tiering_trait, resource.tiering_trait)

    if trait_sum == 3 && consumer.size >= resource.size
        link = 1
    else
        link = 0
    end
    return link
end

_pfim_link(sp1, sp2)