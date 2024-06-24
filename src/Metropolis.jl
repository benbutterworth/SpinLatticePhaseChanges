# procedure for running Metropolis algorithm
export β, σ, ising_energy, run_metropolis, ΔE


#========================= PHYSICAL SYSTEM INFORMATION ========================#
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

#=========================== CONTRIBUTIONS TO ENERGY ==========================#
"""
    neighbourinteraction(spingrid::Matrix{Spin})
Return the contribution to the energy of nearest neighbour interactions in a
spin lattice, counting each pair exactly once.
"""
function neighbourinteraction(spinmatrix::Matrix{Spin})
    endrow, endcol = size(spinmatrix)
    Σ = 0
    for row in 1:endrow-1
        for col in 1:endcol-1
            Σ += spinmatrix[row, col] * spinmatrix[row + 1, col] + spinmatrix[row, col] * spinmatrix[row, col + 1]
        end
    end

    for row in 1:endrow-1
        Σ += spinmatrix[row, endcol] * spinmatrix[row + 1, endcol]
    end

    for col in 1:endcol-1
        Σ += spinmatrix[endrow, col] * spinmatrix[endrow, col + 1]
    end

    Σ
end

"""
    magneticinteraction(spinmatrix::Matrix{Spin}, B::Tuple{Real, Real})
Return the unitles energy contribution from a lattice of spins interacting 
with an external magnetic field B = (|B|, θ)
"""
function magneticinteraction(spinmatrix::Matrix{Spin}, B::Tuple{Real, Real})
    0
end

#
# WILL NO LONGER WORK 24/06/2024 - MUST BE REWRITTEN
#
"""
    ΔE(spingrid::SpinGrid, x::Int, y::Int)
Return the change in energy of _spingrid_ caused by flipping the Spin at _(x,y)_.
"""
function ΔE(spingrid::SpinGrid, x::Int, y::Int)
    #only do calculation for affected region - minimise computation
    sub = segment(spingrid, x,y)
    coords = segmentcenter(spingrid, x, y)
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
    ising_energy(spingrid::SpinGrid, J::Real, B::Tuple{Real, Real})
Return the energy (in Joules) of a spin lattice with interaction strength , *J*,
between nearest neighbours in the prescence of the magnetic field B in polar 
form *(|B|,θ)*.
"""
function ising_energy(spingrid::SpinGrid, J::Real, B::Tuple{Real, Real})
    # J is interaction coefficient (nounits)
        # will determine curie temp!
    # B is magnetic field applied as polar vector B = (|B|,θ)
    b, θ = B
    h = XYSpin(θ)
    # energy due to nearest neighbour spin interactions
    nn = 1/2 * J * σ(1)^2 * energy(spingrid)
    # energy due to overlap w. magnetic field
    mg = g * μ * b * σ(1) *  sum(x->*(x,h), spins(spingrid))
    nn + mg
end

"""
    ising_energy(spingrid::SpinGrid, J::Real)
Return the energy (in Joules) of a spin lattice with interaction strength , *J*,
between nearest neighbours in the absence of a magnetic field.
"""
function ising_energy(spingrid::SpinGrid, J::Real)
    # J is interaction coefficient (nounits)
    # energy due to nearest neighbour interactions
    nn = 1/2 * J * σ(1)^2 * energy(spingrid)
    nn
end

"""
    run_metropolis(spingrid::SpinGrid, n::Int)
Execute the metropolis spin-flipping algorithm _n_ times on the SpinGrid _spingrid_.
"""
function run_metropolis(spingrid::SpinGrid, n::Int)
    0
end