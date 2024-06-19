export SpinLattice, SpinGrid
export energy, energy!, spins, flip!

import Base: size, getindex, setindex!

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
    t = SpinGrid(size, s, 0)
    e = energy(spins(t))
    SpinGrid(size, s, e)
end

#============================= ACCESSOR FUNCTIONS =============================#
size(sg::SpinGrid) = sg.size
spins(sg::SpinGrid) = sg.spins
energy(sg::SpinGrid) = sg.energy

function getindex(sg::SpinGrid, x::Int, y::Int)
    spins(sg)[x,y]
end

function getindex(sg::SpinGrid, xr::UnitRange{Int}, yr::UnitRange{Int})
    spins(sg)[xr,yr]
end

function setindex!(sg::SpinGrid, s::Spin, x::Int, y::Int)
    spins(sg)[x,y] = s
end

#============================ CALCULATE THE ENERGY ============================#
"""
    energy!(sg::SpinGrid)
Update the unitless energy of _sg_ to the energy of its spin system _sg.spins_.
"""
function energy!(sg::SpinGrid)
    # Update the energy of a spingrid based on its spins
    sg.energy = energy(spins(sg))
end

"""
    energy(spingrid::Matrix{Spin})
Return the unitless nearest neighbour energy of the Spin Matrix _s_.
"""
function energy(spingrid::Matrix{Spin})
    x, y = size(spingrid)
    g(i, j) = spingrid[i, j]
    σ = 0
    # Sum of corner elements
    σ += g(1, 1) * g(1, 2) + g(1, 1) * g(2, 1)
    σ += g(1, y) * g(1, y - 1) + g(1, y) * g(2, y)
    σ += g(x, 1) * g(x - 1, 1) + g(x, 1) * g(x, 2)
    σ += g(x, y) * g(x - 1, y) + g(x, y) * g(x, y - 1)

    # Sum of top & bottom rows
    for i in 2:x-1
        #upper row
        σ += g(i, 1) * g(i - 1, 1) + g(i, 1) * g(i + 1, 1) + g(i, 1) * g(i, 2)
        #lower row
        σ += g(i, y) * g(i - 1, y) + g(i, y) * g(i + 1, y) + g(i, y) * g(i, y - 1)
    end

    # Sum of left and right collumns
    for j in 2:y-1
        # left collumn
        σ += g(1, j) * g(1, j - 1) + g(1, j) * g(1, j + 1) + g(1, j) * g(2, j)
        # right collumn
        σ += g(x, j) * g(x, j - 1) + g(x, j) * g(x, j + 1) + g(x, j) * g(x - 1, j)
    end

    # sum of middle elements
    for i in 2:x-1
        for j in 2:y-1
            σ += g(i, j) * g(i - 1, j) + g(i, j) * g(i + 1, j) + g(i, j) * g(i, j - 1) + g(i, j) * g(i, j + 1)
        end
    end

    σ
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
    flip!(sg::SpinLattice, x::Int, y::Int)
Alter the Spin on _sg_ at point *(x,y)* to point in the opposite direction.
"""
function flip!(sg::SpinLattice, x::Int, y::Int)
    sg.spins[x, y] = flip(sg.spins[x, y])
end
