# procedure for running Metropolis algorithm
export β, σ, ising_energy, run_metropolis, ΔE


#========================= PHYSICAL SYSTEM INFORMATION ========================#
"""
    β(T::Real)
Return the thermodynamic beta for a temperature *T*.
"""
function β(T::Real)
    T = convert(Float64, T)
    1 / (κ * T)
end

"""
    σ(n::Int)
Return the spin of a n/2 spin particle in [J][s].
"""
function σ(n::Int)
    n * ħ / 2
end

#=========================== CONTRIBUTIONS TO ENERGY ==========================#
function rowpairproduct(mat::Matrix, row::Int, col::Int)
    mat[row, col] * mat[row+1, col]
end

function colpairproduct(mat::Matrix, row::Int, col::Int)
    mat[row, col] * mat[row, col+1]
end

"""
    neighbourinteraction(spingrid::SpinGrid)
Return the contribution to the energy of nearest neighbour interactions in a
spin lattice, counting each pair exactly once.
"""
function neighbourinteraction(spingrid::SpinGrid, J::Real)
    spinmatrix = spins(spingrid)
    endrow, endcol = size(spinmatrix)
    Σ = 0

    for row in 1:endrow-1
        for col in 1:endcol-1
            Σ += rowpairproduct(spinmatrix, row, col) + colpairproduct(spinmatrix, row, col)
        end
    end

    for row in 1:endrow-1
        Σ += rowpairproduct(spinmatrix, row, endcol)
    end

    for col in 1:endcol-1
        Σ += colpairproduct(spinmatrix, endrow, col)
    end

    -J * Σ * (ħ^2 / 4)
end

"""
    magneticinteraction(spingrid::SpinGrid, H::Tuple{Real, Real})
Return the unitless energy contribution from a lattice of spins interacting 
with an external applied magnetic field H = (|H|, θ)
"""
function magneticinteraction(spingrid::SpinGrid, H::Tuple{Real,Real})
    spinmatrix = spins(spingrid)
    appliedFieldStrength = H[1]
    appliedFieldAsSpin = XYSpin(H[2])

    magMoment = sum(
        s -> s * appliedFieldAsSpin,
        spinmatrix
    )

    -g * μ * (ħ/2) * magMoment * appliedFieldStrength 
end

#===================== TOTAL ENERGY AND CHANGES IN ENERGY =====================#

"""
    ising_energy(spingrid::SpinGrid, J::Real, H=(0., 0.))
Return the energy (in Joules) of a spin lattice `spingrid` with interaction 
strength , `J`, between nearest neighbours in the prescence of an applied 
magnetic field `H` in polar form (|H|,θ).
"""
function ising_energy end

function ising_energy(spingrid::SpinGrid, J::Real, H::Tuple{Real,Real})
    # nearest neighbour and magnetif moment energy summation
    neighbourinteraction(spingrid, J) + magneticinteraction(spingrid, H)
end

function ising_energy(spingrid::SpinGrid, J::Real)
    # NO APPLIED FIELD CASE
    neighbourinteraction(spingrid, J)
end

"""
    ΔE(spingrid::SpinGrid, x::Int, y::Int, J::Real, H=(0, 0))
Return the change in energy of `spingrid` caused by flipping Spin _(x,y)_.
"""
function ΔE(spingrid::SpinGrid, x::Int, y::Int, J::Real, H::Tuple{Real,Real}=(0, 0))
    # segment then calculate energy before & after flipping. INCLUDE H.
    energyBeforeFlip = ising_energy(spingrid, J, H)
    energyAfterFlip = ising_energy(flip(spingrid, x, y), J, H)
    energyAfterFlip - energyBeforeFlip
end


#======================= EXECUTE SPINFLIPPING ALGORITHM =======================#
"""
    run_metropolis(spingrid::SpinGrid, temperature::Real nFlips::Int)
Execute the metropolis spin-flipping algorithm `nFlips` times `spingrid`.
"""
function run_metropolis(spingrid::SpinGrid, temperature::Real, nFlips::Int)
    J = 7/2
    H = (0,0)
    nrows, ncols = size(spingrid)
    let spingrid = spingrid # change local not global variable? #memory issues?
        for i in 1:nFlips
            randrow = rand(1:nrows); randcol = rand(1:ncols)
            r = rand()
            threshold = exp(-β(temperature) * ΔE(spingrid, randrow, randcol, J, H))
            if r < threshold
                flip!(spingrid, randrow, randcol)
            end
        end
    end
    spingrid
end