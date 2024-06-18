export SpinLattice, SpinGrid
export energy, energy!, spins, flip!

#============================= STRUCT DEFINITIONS =============================#
abstract type SpinLattice end

"""
    SpinGrid <: SpinLattice
A type for a 2D grid of Spins with an associated energy.
"""
mutable struct SpinGrid <: SpinLattice
    # 2 dimensional Spin lattice containing only ↑ & ↓ spins
    size::Tuple{Int,Int}
    spins::Matrix{Spin}
    energy::Float64
end

"""
    SpinGrid(size::Tuple{Int,Int}, p::Float64=0.5)
Return a SpinGrid whose spins point ↑ with probability _p_.
"""
function SpinGrid(size::Tuple{Int,Int}, p::Float64=0.5)
    n1, n2 = size
    s = map(x -> ISpin(x, p), rand(n1, n2))
    e = energy(s)
    SpinGrid(size, e, s)
end

#============================= ACCESSOR FUNCTIONS =============================#
size(sg::SpinGrid) = sg.size
spins(sg::SpinGrid) = sg.spins
energy(sg::SpinGrid) = sg.energy

#============================ CALCULATE THE ENERGY ============================#
"""
    energy!(sg::SpinGrid)
Update the energy of _sg_ to match the energy of its spin system _sg.spins_.
"""
function energy!(sg::SpinGrid)
    # Update the energy of a spingrid based on its spins
    sg.energy = energy(spins(sg))
end

"""
    energy(s::Matrix{ISpin})
Return the unitless nearest neighbour energy of the Spin Matrix _s_.
"""
function energy(s::Matrix{Spin})
    0
end

#============================= DISPLAYING SPINGRID ============================#
function show(io::IO, sg::SpinGrid)
    n1, n2 = size(sg)
    println("$n1 x $n2 SpinGrid")
    println(io, spins(sg))
    println(io, "Energy : ", energy(sg))
end

#================================= FLIP A SPIN ================================#
"""
    flip!(sg::SpinLattice, coords::Tuple{Int,Int})
Alter the Spin on _sg_ at point _coords_ to point in the opposite direction.
"""
function flip!(sg::SpinLattice, coords::Tuple{Int,Int})
    x, y = coords
    sg.spins[x, y] = flip(sg.spins[x, y])
end