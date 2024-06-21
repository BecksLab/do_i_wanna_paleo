"""
feeding <: PFIM

feeding categories for PFIM model
"""
abstract type feeding end

# feeding types
struct predator <: feeding end
struct suspension_feed <: feeding end
struct surficial_feed <: feeding end
struct producer <: feeding end

"""
motility <: PFIM

motility categories for PFIM model
"""
abstract type motility end

# motility types
struct nonmotile_attached <: motility end
struct nonmotile_unattached <: motility end
struct faculatative_attached <: motility end
struct faculatative_unattached <: motility end
struct motile_slow <: motility end
struct motile_fast <: motility end

"""
tiering <: PFIM

tier categories for PFIM model
"""
abstract type tier end

# tiering types
struct infaunal <: tier end
struct semi_infaunal <: tier end
struct surficial <: tier end
struct erect <: tier end
struct pelagic <: tier end
struct semi_aquatic <: tier end