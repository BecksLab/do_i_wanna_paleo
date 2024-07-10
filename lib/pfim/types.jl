"""
feeding <: PFIM

feeding categories for PFIM model
"""
abstract type feeding end

# feeding types
struct carnivore <: feeding end
struct deposit_surficial <: feeding end
struct deposit_mining <: feeding end
struct deposit_mining_chemosymbiotic <: feeding end
struct grazer_carnivore <: feeding end
struct grazer_omnivore <: feeding end
struct grazer_herbivore <: feeding end
struct suspension <: feeding end
struct suspension_chemosymbiotic <: feeding end
struct parasitic <: feeding end
struct scavenger <: feeding end
struct microcarnivore <: feeding end

"""
motility <: PFIM

motility categories for PFIM model
"""
abstract type motility end

# motility types
struct fast_moving <: motility end
struct slow_moving <: motility end
struct facultative <: motility end
struct nonmotile <: motility end

"""
tiering <: PFIM

tier categories for PFIM model
"""
abstract type tier end

# tiering types
struct nektonic <: tier end
struct epifaunal_erect <: tier end
struct epifaunal_surficial <: tier end
struct semi_infaunal <: tier end
struct shallow_infaunal <: tier end
struct deep_infaunal <: tier end

"""
sizes <: PFIM

size categories for PFIM model
"""
abstract type sizes end

# size types
struct large <: sizes end
struct medium <: sizes end
struct parasitic_medium <: sizes end
struct scavenger_medium <: sizes end
struct scavenger_large <: sizes end
struct microcarnivore_medium <: sizes end
struct microcarnivore_large <: sizes end
struct small <: sizes end
struct parasitic_small <: sizes end
struct scavenger_small <: sizes end
struct microcarnivore_small <: sizes end
struct tiny <: sizes end
struct parasitic_tiny <: sizes end
struct scavenger_tiny <: sizes end
struct microcarnivore_tiny <: sizes end
