include(joinpath("types.jl"))

# Define rules for each trait type

# feeding rules
feeding_rules(consumer::T1, resource::T2) where {T1<:feeding,T2<:feeding} = 0
feeding_rules(consumer::predator, resource::suspension) = 1
feeding_rules(consumer::predator, resource::surficial) = 1
feeding_rules(consumer::predator, resource::predator) = 1
feeding_rules(consumer::suspension, resource::producer) = 1
feeding_rules(consumer::surficial, resource::producer) = 1

# motility rules
motility_rules(consumer::T1, resource::T2) where {T1<:motility,T2<:motility} = 0
motility_rules(consumer::motile_fast, resource::T) where {T<:motility} = 1
motility_rules(consumer::motile_fast, resource::motile_fast) = 1
motility_rules(consumer::motile_slow, resource::T) where {T<:motility} = 1
motility_rules(consumer::motile_slow, resource::motile_fast) = 0
motility_rules(consumer::motile_slow, resource::T) where {T<:motility} = 1
motility_rules(consumer::facultative_unattached, resource::motile_fast) = 0
motility_rules(consumer::facultative_unattached, resource::T) where {T<:motility} = 1
motility_rules(consumer::facultative_attached, resource::facultative_unattached) = 1
motility_rules(consumer::facultative_attached, resource::motile_slow) = 1
motility_rules(consumer::facultative_attached, resource::nonmotile_unattached) = 1
motility_rules(consumer::nonmotile_unattached, resource::nonmotile_unattached) = 1
motility_rules(consumer::nonmotile_attached, resource::nonmotile_unattached) = 1

# tiering rules
tiering_rules(consumer::T1, resource::T2) where {T1<:tier,T2<:tier} = 0
tiering_rules(consumer::semi_aquatic, resource::T) where {T<:tier} = 1
tiering_rules(consumer::semi_aquatic, resource::semi_infaunal) = 0
tiering_rules(consumer::semi_aquatic, resource::infaunal) = 0
tiering_rules(consumer::pelagic, resource::T) where {T<:tier} = 1
tiering_rules(consumer::pelagic, resource::infaunal) = 0
tiering_rules(consumer::erect, resource::T) where {T<:tier} = 1
tiering_rules(consumer::erect, resource::semi_aquatic) = 0
tiering_rules(consumer::erect, resource::infaunal) = 0
tiering_rules(consumer::semi_infaunal, resource::T) where {T<:tier} = 1
tiering_rules(consumer::semi_infaunal, resource::semi_aquatic) = 0
tiering_rules(consumer::semi_infaunal, resource::pelagic) = 0
tiering_rules(consumer::infaunal, resource::infaunal) = 1
tiering_rules(consumer::infaunal, resource::semi_infaunal) = 1

# size rules
size_rules(consumer::T1, resource::T2) where {T1<:sizes,T2<:sizes} = 0
size_rules(consumer::very_large, resource::T) where {T<:sizes} = 1
size_rules(consumer::large, resource::medium) = 1
size_rules(consumer::large, resource::small) = 1
size_rules(consumer::medium, resource::small) = 1
size_rules(consumer::small, resource::small) = 1
