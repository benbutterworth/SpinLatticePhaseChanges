# measurement metrics for spingrids

function magnetisation end

"""
    meanspindirection(sg::SpinGrid) -> Float64
Return the average direction of all spins in `sg` in radians.
"""
function meanspindirection(sg::SpinGrid)
    xyspingrid = map(spins(sg)) do x
        convert(XYSpin, x)
    end |> SpinGrid

    spindirections = map(spin, spins(xyspingrid))

    mean(spindirections)
end

"""
    magnetisation(sg::SpinGrid)
Return 0
"""
function magnetisation(sg::SpinGrid)
    0
end

function entropy end