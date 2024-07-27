# SpinLatticePhaseChanges
*A simple package to simulate continuous phase changes in a 2 dimensional spin lattice with the Ising model.*

Systems that exhibit phase changes are often complex and require immense amounts of information to fully parameterise. The Ising model is a toy model of a system of 2-state objects, most commonly a lattice of ferromagnetic spins, often used to investigate second order phase changes. Despite the Ising model's simplicity, it retains a number of important characteristics you would find in more complex systems.

In this implementation of the Ising model, we consider a lattice of electron spins that can be either spin-up or spin-down. The *order parameter* that characterises the phase change of this system is its average magnetization, $m$,  of each site. It will be non zero *only* when in an ordered phase. By varying simulation parameters like the exchange energy between adjacent pairs of electrons and the applied magnetic field strength, many different systems can be investigated.

## Core Structures
`Spin`
The spin of an electron, which can either be pointing up (true) or down (false).

`SpinGrid`
A 2 dimensional lattice of `Spin` structures. This represents the orientation of valence electron spins in a ferromagnetic metal, for instance.

## Core Method
`run_metropolis(spingrid::SpinGrid)`
Interactively run a simulation of the Ising model using the metropolis spin-flipping algorithm. Given a random spin lattice, running this method simulates the system coming into thermal equilibrium with its environment at tempereature *T*. 

## Notes on Optimisation

Most performance gains have been made from optimising ΔE with `segment` methods to only consider parts of the spin lattice which would be affected from flipping spins. This was designed to be parallelised by calculating ΔE on each segment on a unique thread. SIMD Methods could also be used, splitting a `SpinGrid` into parts and broadcasting them to a cluster.

A spingrid typically consumes 15% more memory than a similarly sized Float64-Array and will need to be considered in your implementation.

## Examples

```julia

julia> spingrid = SpinGrid(100,100)
Spin[↓ ↑ … ↓ ↓; ↑ ↑ … ↓ ↑; … ; ↑ ↑ … ↑ ↑; ↓ ↑ … ↓ ↓]

julia> # Run a simulation at the critical point

julia> spingrid = run_metropolis(spingrid)

Temperature of the system (K) : 76

Heisenberg exchange energy (eV) : 3.5

Applied magnetic field strength (T) : 0

Direction of applied field (rad) : 0

Number of ising model flips (Int64) : 10000
Spin[↓ ↓ … ↓ ↓; ↓ ↓ … ↓ ↓; … ; ↓ ↓ … ↑ ↑; ↓ ↓ … ↓ ↑]

```

## Technical Information

In this project I have used the following form of the Ising Hamiltonian, $\mathcal{H}\_I$, where $S_i \in \{±\frac{\hbar}{2}\}$ is the spin of the electron at site $i$, $\mu\_i$ it's magnetic moment, $J\_{ij}$ the Heisenberg exchange energy between electrons $i$ and $j$, and $\bar H$ is the applied magnetic field.

``math
\mathcal{H}_I = -\sum_{i,j} J_{ij} \ \bar S_i \cdot \bar S_j - \sum_{i} \bar \mu_i \cdot \bar H 
``

There is no standard form of the Ising model in the literature. I regard this form as the clearest which retains the full generality of the system.

## Credit
*Ben Butterworth 2024*

This was a fun little project and I am happy with how it's finished. One day I'd like to come back to it and develop it further.