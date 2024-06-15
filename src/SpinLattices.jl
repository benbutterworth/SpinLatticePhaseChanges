abstract type SpinLattice end

mutable struct SpinGrid <: SpinLattice
    # 2 dimensional Spin lattice containing only ↑ & ↓ spins
    size::Tuple{Int,Int}
    energy::Float64
    spins::Matrix{ISpin}
    history::Vector{Tuple{Int,Int}}
end

# generate a SpinGrid fillied with spins biased towards ↑ or ↓ based on p.
function SpinGrid(size::Tuple{Int,Int}, p::Float64=0.5)
    n1, n2 = size
    s = map(x -> ISpin(x, p), rand(n1, n2))
    e = energy(s)
    h = Vector{Tuple{Int,Int}}(undef,0)
    SpinGrid(size, e, s, h)
end

#============================= ACCESSOR FUNCTIONS =============================#
size(sg::SpinGrid)      = sg.size
spins(sg::SpinGrid)     = sg.spins
energy(sg::SpinGrid)    = sg.energy
history(sg::SpinGrid)   = sg.history

#============================ CALCULATE THE ENERGY ============================#
function energy!(sg::SpinGrid)
    # Update the energy of a spingrid based on its spins
    sg.energy = energy(spins(sg))
end

function energy(s::Matrix{ISpin})
    # calculate the energy of a matrix filled with spins
    0
end

#============================= DISPLAYING SPINGRID ============================#
function show(io::IO, sg::SpinGrid)
    n1,n2 = size(sg)
    println("$n1 x $n2 SpinGrid")
    println(io, spins(sg))
    println(io, "Energy : ", energy(sg))
end

#================================= FLIP A SPIN ================================#
function flip!(sg::SpinGrid, coords::Tuple{Int,Int})
    x,y = coords...
    sg.spins[x,y] = flip(sg.spins[x,y])
end