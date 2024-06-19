# procedure for running Metropolis algorithm
export ising_energy, run_metropolis, ΔE


"""
    ΔE(sg::SpinGrid, x::Int, y::Int)
Return the change in energy of _sg_ caused by flipping the Spin at _(x,y)_.
"""
function ΔE(sg::SpinGrid, x::Int, y::Int)
    coords = (0,0)
    #find new coordinates using slice
    sub = slice(sg, x,y)
    coords = slicecenter(sg, x, y)
    E_1 = energy(sub)
    0
end

"""
    ising_energy(sg::SpinGrid)
Return the energy of a SpinGrid _sg_ in Joules.
"""
function ising_energy(sg::SpinGrid)
    0
end

"""
    run_metropolis(sg::SpinGrid, n::Int)
Execute the metropolis spin-flipping algorithm _n_ times on the SpinGrid _sg_.
"""
function run_metropolis(sg::SpinGrid, n::Int)
    0
end