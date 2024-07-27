"""
    SpinLatticePhaseChanges
Simulate the continuous phase transition of a spin lattice using the Metropolis
algorithm.
"""
module SpinLatticePhaseChanges

include("constants.jl")
include("Spins.jl")
include("SpinLattices.jl")
include("segment.jl")
include("Metropolis.jl")

end
