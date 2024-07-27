# SpinLatticePhaseChanges
A simple package to simulate continuous phase changes in a 2 dimensional spin lattice with the Ising model.

Systems that exhibit phase changes are often complex and require immense amounts of information to fully parameterise; the Ising model is a toy model for continuous phase changes that retains a surprisingly large number of important characteristics despite its simplicity.

In this implementation of the Ising model, we consider a lattice of electron spins that are directed either up or down. The order parameter that characterises the phase change of this system is its average magnetization, $m$,  of each sit. It will be non zero only when in an ordered phase. By varying simulation parameters like the heisenberg exchange energy, temperature and field strength, many different systems can be simulated and investigations into the specific changes the spin lattice undergoes can be investigated.

## Core Structures
`Spin`

`SpinGrid`

## Core Method
`run_metropolis(spingrid::SpinGrid)`


## Notes on Optimisation

- Serially efficient using segmentation
- Distributing as-is will not improve efficiency due to latency >> execution for each part
- Multithreading will increace efficiency, and is a future aim of the project.

A spingrid typically consumes 15% more memory than a similarly sized Float64-Array, so consider this in your implementation.

## Examples

## Credit