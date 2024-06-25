export segment, segmentcenter

function getsaferange(val::Int, maxval::Int, minval::Int=1)
    if val ≤ minval + 1
        [val - minval, 2]
    elseif mod(val + 1, maxval) ≤ 1
        [2, maxval - val]
    else
        [2, 2]
    end
end

"""
    segmentsize(t::Tuple{Int,Int},  x::Int, y::Int)
Return the distances of a coordinate t from the edge of a matrix (↑, ↓, ←, →).
"""
function segmentsize(t::Tuple{Int,Int}, x::Int, y::Int)
    xmax, ymax = t # xmax↓  ymax→

    safex = getsaferange(x, xmax)
    safey = getsaferange(y, ymax)

    vcat(safex, safey) |> Tuple
end

"""
    segment(m::Matrix, x::Int, y::Int)
Return the largest possible (up to 5x5) segment of the matrix _m_ branching out
from the central point _(x,y)_.
"""
function segment(m::Matrix, x::Int, y::Int)
    if size(m) < (5,5)
        @error "Too small to segment"
    end

    safeup, safedown, safeleft, saferight = segmentsize(size(m), x, y)
    m[x-safeup : x+safedown, y-safeleft:y+saferight]
end

"""
    segment(spingrid::SpinLattice, x::Int, y::Int)
Return a subset of the SpinLattice *spingrid* containing all the points on the
lattice that would be affected by flipping the spin *(x,y)*.
"""
function segment(sg::SpinLattice, x::Int, y::Int)
    segment(spins(sg), x, y) |> SpinGrid
end

"""
    segmentcenter(t::Tuple{Int,Int}, x::Int, y::Int)
Return the coordinates of the point *(x,y)* in the new custom segment of the
object with size t.
"""
function segmentcenter(t::Tuple{Int,Int}, x::Int, y::Int)
    fromLUcorner = segmentsize(t, x, y) .+ 1
    fromLUcorner[1], fromLUcorner[3]
end

"""
    segmentcenter(m::Matrix, x::Int, y::Int)
Return the coordinates of the point *(x,y)* in the custom segment taken of the
matrix *m*.
"""
function segmentcenter(m::Matrix, x::Int, y::Int)
    segmentcenter(size(m), x, y)
end

"""
    segmentcenter(sl::SpinLattice, x::Int, y::Int)
Return the coordinates of the point *(x,y)* in the custom segment taken of the
matrix *m*.
"""
function segmentcenter(sl::SpinLattice, x::Int, y::Int)
    segmentcenter(size(sl), x, y)
end
