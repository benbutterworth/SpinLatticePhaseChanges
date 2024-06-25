export SpinLattice, SpinGrid, XYSpinGrid, spins, flip!
import Base: show, getindex, setindex!, size

#========================== LOGIC FOR ERROR CHECKING ==========================#
function is2D(M::Matrix)
    if length(size(M)) == 2
        true
    else
        false
    end
end #all matrices are 2d, redundant!

function atLeast5x5(M::Matrix)
    if size(M) ≥ (5, 5)
        true
    else
        false
    end
end

#========================= ABSTRACT TYPE & STRUCT DEF =========================#
abstract type SpinLattice end

"""
    SpinGrid <: SpinLattice
Type representing a 2 dimensional lattice of spins.
"""
mutable struct SpinGrid <: SpinLattice
    spins::Matrix{Spin}

    function SpinGrid(spingrid::Matrix{T})  where T<:Spin
        if !is2D(spingrid)
            @error "spingrid is not 2D"
        end
        if !atLeast5x5(spingrid)
            @warn "spingrid is small - size < (5,5). Take care when using segment."
        end
        new(spingrid)
    end

end

#================================ CONSTRUCTORS ================================#
"""
    SpinGrid(nrows::Int, ncols::Int, probSpinUp::Float64=0.5)
Return a SpinGrid of 1 dimensional spins of size *(nrows, ncols)* pointing in
the ̂x direction with probability *probSpinUp*.
"""
function SpinGrid(nrows::Int, ncols::Int, probSpinUp::Float64=0.5)
    map(
        x -> ISpin(x, probSpinUp),
        rand(nrows, ncols)
    ) |> SpinGrid
end

"""
    XYSpinGrid(nrows::Int, ncols::Int)
Return a SpinGrid of 2 dimensional spins of size *(nrows, ncols)* oriented in
a random direction in the XY plane.
"""
function XYSpinGrid(nrows::Int, ncols::Int)
    map(
        XYSpin,
        rand(nrows, ncols) .* 2π
    ) |> SpinGrid
end

#================================== ACCESSORS =================================#
spins(spingrid::SpinGrid) = spingrid.spins
size(spingrid::SpinGrid) = size(spins(spingrid))

#========================= INDEXING AND SETTING RULES =========================#
function getindex(spingrid::SpinGrid, x::Int, y::Int)
    spins(spingrid)[x, y]
end

function getindex(spingrid::SpinGrid, xr::UnitRange{Int}, yr::UnitRange{Int})
    spins(spingrid)[xr, yr]
end

function setindex!(spingrid::SpinGrid, s::Spin, x::Int, y::Int)
    spins(spingrid)[x, y] = s
end

#============================== SHOWING SPINGRIDS =============================#
function show(io::IO, spingrid::SpinGrid)
    show(io, spins(spingrid))
end

#================================ SPIN FLIPPING ===============================#
"""
    flip!(spingrid::SpinGrid, x::Int, y::Int)
Flip the Spin on *spingrid* at point *(x,y)* to point in the opposite direction.
"""
function flip!(spingrid::SpinGrid, x::Int, y::Int)
    spingrid.spins[x, y] = flip(spingrid.spins[x, y])
end

"""
    flip(spingrid::SpinGrid, x::Int, y::Int)
Return a SpinGrid identical to *spingrid* but with the Spin on *spingrid* at 
point *(x,y)*  flipped in the opposite direction.
"""
function flip(spingrid::SpinGrid, x::Int, y::Int)
    spinmat = copy(spins(spingrid))
    spinmat[x,y] = flip(spinmat[x,y])
    SpinGrid(spinmat)
end