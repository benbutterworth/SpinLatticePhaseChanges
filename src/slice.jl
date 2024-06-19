export slice, slicecenter

"""
    slice(t::Tuple{Int,Int},  x::Int, y::Int)
Return the distances of a coordinate t from the edge of a matrix (↑, ↓, ←, →).
"""
function slice(t::Tuple{Int,Int}, x::Int, y::Int)
    # assume grid is at least 5x5 for ease
    nx, ny = t # nx↓  ny→
    if x ≤ 2
        xu, xd = (x - 1, 2)
    elseif mod(x + 1, nx) ≤ 1
        d = nx - x #always +ve ∈ [0,1,2]
        xu, xd = (2, d)
    else
        xu, xd = (2, 2)
    end

    if y ≤ 2
        yl, yr = (y - 1, 2)
    elseif mod(y + 1, ny) ≤ 1
        d = ny - y #always +ve ∈ [0,1,2]
        yl, yr = (2, d)
    else
        yl, yr = (2, 2)
    end

    xu, xd, yl, yr
end

"""
    slice(m::Matrix,  x::Int, y::Int)
Return the largest possible (up to 5x5) slice of the matrix _m_ branching out
from the central point _(x,y)_.
"""
function slice(m::Matrix, x::Int, y::Int)
    xu, xd, yl, yr = slice(size(m), x, y)
    m[x-xu:x+xd, y-yl:y+yr]
end

"""
    slice(sg::SpinLattice,  x::Int, y::Int)
Return the largest possible (up to 5x5) slice of the SpinLattice _m_ branching
out from the central point _(x,y)_.
"""
function slice(sg::SpinLattice, x::Int, y::Int)
    xu, xd, yl, yr = slice(size(sg), x, y)
    sg[x-xu:x+xd, y-yl:y+yr]
end

"""
    slicecenter(t::Tuple{Int,Int}, x::Int, y::Int)
Return the coordinates of the point *(x,y)* in the new custom slice of the
object with size t.
"""
function slicecenter(t::Tuple{Int,Int}, x::Int, y::Int)
    r = [i for i ∈ slice(t, x, y)]
    coords = (r[1]+1, r[3]+1)
    coords
end

"""
    slicecenter(m::Matrix, x::Int, y::Int)
Return the coordinates of the point *(x,y)* in the custom slice taken of the
matrix *m*.
"""
function slicecenter(m::Matrix, x::Int, y::Int)
    t = size(m)
    r = [i for i ∈ slice(t, x, y)]
    coords = (r[1]+1, r[3]+1)
    coords
end
