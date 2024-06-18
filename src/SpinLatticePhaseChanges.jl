"""
    SpinLatticePhaseChanges
Simulate the continuous phase transition of a spin lattice using the Metropolis
or Wolff algorithm and investigating its thermodynamic characteristics.
"""
module SpinLatticePhaseChanges

import Base: +, -, *, /
import Base: show, convert, promote_rule, size

include("Spins.jl")
include("SpinLattices.jl")

end
