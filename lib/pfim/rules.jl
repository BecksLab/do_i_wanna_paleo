include(joinpath("types.jl"))

# Define rules for each trait type

# feeding rules
feeding_rules(consumer::T, resource::T) where {T <: feeding} = 0
feeding_rules(consumer::predator, resource::suspension_feed) = 1
feeding_rules(consumer::predator, resource::surficial_feed) = 1
feeding_rules(consumer::predator, resource::predator) = 1
feeding_rules(consumer::suspension_feed, resource::producer) = 1
feeding_rules(consumer::surficial_feed, resource::producer) = 1

# motility rules
motility_rules(consumer::T, resource::T) where {T <: motility} = 0
motility_rules(consumer::motile_fast, resource::T) where {T <: motility} = 1
motility_rules(consumer::motile_fast, resource::motile_fast) = 1
motility_rules(consumer::motile_slow, resource::T) where {T <: motility} = 1
motility_rules(consumer::motile_slow, resource::motile_fast) = 0
motility_rules(consumer::motile_slow, resource::T) where {T <: motility} = 1
motility_rules(consumer::faculatative_unattached, resource::motile_fast) = 0
motility_rules(consumer::faculatative_unattached, resource::T) where {T <: motility} = 1
motility_rules(consumer::faculatative_attached, resource::faculatative_unattached) = 1
motility_rules(consumer::faculatative_attached, resource::motile_slow) = 1
motility_rules(consumer::faculatative_attached, resource::nonmotile_unattached) = 1
motility_rules(consumer::nonmotile_unattached, resource::nonmotile_unattached) = 1
motility_rules(consumer::nonmotile_attached, resource::nonmotile_unattached) = 1

# tiering rules
tiering_rules(consumer::T, resource::T) where {T <: tier} = 0
tiering_rules(consumer::semi_aquatic, resource::T) where {T <: tier} = 1
tiering_rules(consumer::semi_aquatic, resource::semi_infaunal) = 0
tiering_rules(consumer::semi_aquatic, resource::infaunal) = 0
tiering_rules(consumer::pelagic, resource::T) where {T <: tier} = 1
tiering_rules(consumer::pelagic, resource::infaunal) = 0
tiering_rules(consumer::erect, resource::T) where {T <: tier} = 1
tiering_rules(consumer::erect, resource::semi_aquatic) = 0
tiering_rules(consumer::erect, resource::infaunal) = 0
tiering_rules(consumer::surficial, resource::T) where {T <: tier} = 1
tiering_rules(consumer::semi_infaunal, resource::T) where {T <: tier} = 1
tiering_rules(consumer::semi_infaunal, resource::semi_aquatic) = 0
tiering_rules(consumer::semi_infaunal, resource::pelagic) = 0
tiering_rules(consumer::infaunal, resource::infaunal) = 1
tiering_rules(consumer::infaunal, resource::semi_infaunal) = 1
tiering_rules(consumer::infaunal, resource::surficial) = 1