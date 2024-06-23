# procedure for running Metropolis algorithm
export β, σ, ising_energy, run_metropolis, ΔE

"""
    β(T::Real)
Return the thermodynamic beta for a temperature *T*.
"""
function β(T::Real)
    T = convert(Float64, T)
    1/(κ*T)
end

"""
    σ(n::Int)
Return the spin of a n/2 spin particle in [J][s].
"""
function σ(n::Int)
    n * ħ / 2
end

"""
    ΔE(sg::SpinGrid, x::Int, y::Int)
Return the change in energy of _sg_ caused by flipping the Spin at _(x,y)_.
"""
function ΔE(sg::SpinGrid, x::Int, y::Int)
    #only do calculation for affected region - minimise computation
    sub = segment(sg, x,y)
    coords = segmentcenter(sg, x, y)
    # Calculate change in energy
    E_1 = energy(sub)
    sub[coords...] = flip(sub[coords...])
    E_2 = energy(sub)
    sub[coords...] = flip(sub[coords...])
    E_2 - E_1
end

#==============================================================================#
#                                NEEDS TESTING!                                #
#==============================================================================#
"""
    ising_energy(sg::SpinGrid, J::Real, B::Tuple{Real, Real})
Return the energy (in Joules) of a spin lattice with interaction strength , *J*,
between nearest neighbours in the prescence of the magnetic field B in polar 
form *(|B|,θ)*.
"""
function ising_energy(sg::SpinGrid, J::Real, B::Tuple{Real, Real})
    # J is interaction coefficient (nounits)
        # will determine curie temp!
    # B is magnetic field applied as polar vector B = (|B|,θ)
    b, θ = B
    h = XYSpin(θ)
    # energy due to nearest neighbour spin interactions
    nn = 1/2 * J * σ(1)^2 * energy(sg)
    # energy due to overlap w. magnetic field
    mg = g * μ * b * σ(1) *  sum(x->*(x,h), spins(sg))
    nn + mg
end

"""
    ising_energy(sg::SpinGrid, J::Real)
Return the energy (in Joules) of a spin lattice with interaction strength , *J*,
between nearest neighbours in the absence of a magnetic field.
"""
function ising_energy(sg::SpinGrid, J::Real)
    # J is interaction coefficient (nounits)
    # energy due to nearest neighbour interactions
    nn = 1/2 * J * σ(1)^2 * energy(sg)
    nn
end

"""
    run_metropolis(sg::SpinGrid, n::Int)
Execute the metropolis spin-flipping algorithm _n_ times on the SpinGrid _sg_.
"""
function run_metropolis(sg::SpinGrid, n::Int)
    0
end