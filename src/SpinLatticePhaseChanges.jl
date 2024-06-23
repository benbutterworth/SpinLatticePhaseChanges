"""
    SpinLatticePhaseChanges
Simulate the continuous phase transition of a spin lattice using the Metropolis
or Wolff algorithm and investigating its thermodynamic characteristics.
"""
module SpinLatticePhaseChanges

include("constants.jl")
include("Spins.jl")
include("SpinLattices.jl")
include("segment.jl")
include("Metropolis.jl")

end
