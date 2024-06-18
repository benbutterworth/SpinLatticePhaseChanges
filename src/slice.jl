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
        δ = nx - x #always +ve ∈ [0,1,2]
        xu, xd = (2, δ)
    else
        xu, xd = (2, 2)
    end

    if y ≤ 2
        yl, yr = (y - 1, 2)
    elseif mod(y + 1, ny) ≤ 1
        δ = ny - y #always +ve ∈ [0,1,2]
        yl, yr = (2, δ)
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