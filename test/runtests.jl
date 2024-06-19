using SpinLatticePhaseChanges
using Test

@testset "SpinLatticePhaseChanges.jl" begin
    # Write your tests here.
end

@testset "Spins.jl" begin
    # Test ISpin functionality
    s1 = ISpin()
    s2 = ISpin(false)

    @test spin(s1) == 1 && spin(s2) == -1
    @test s1 + s2 == 0
    @test s1 + s1 == 2
    @test s2 + s2 == -2
    @test s1 - s2 == 2
    @test s1 * s2 == -1
    @test flip(s2) == s1

    # Test XYSpin functionality
    s1 = XYSpin()
    s2 = XYSpin(π / 2)
    s3 = XYSpin(3π / 2)
    s = [s1,s2,s3]

    @test map(spin, s) == [0, π/2, 3π/2]
    @test s1 + s2 == spin(s2)
    @test s2 + s3 == spin(s1)
    @test s2 - s3 == s3 - s2 == Float64(π)
    @test XYSpin(ISpin()) == s1
    @test ISpin(s2) == ISpin()
    @test ISpin(s3) == ISpin(false)
    @test flip(s2) == s3
    @test flip(s3) == s2
    @test map(x->nudge(x,π), s) == map(flip, s)
end


@testset "SpinLattices.jl" begin
    # Test SpinLattice structs
    sg = SpinGrid(
        (3,3),
        map(ISpin,[1 1 0; 0 0 1; 0 1 1]),
        -4.0
    )
    sx = SpinGrid(
        (3,3),
        map(XYSpin,[0 0.5 1; 2 3 4; 5 4 2]),
        -0.22638954227189456
    )
    s = SpinGrid((100,100), 1.0)

    @test energy(s) == 39600.0

    @test size(sg) == (3,3)
    @test map(spin,spins(sg)) == [1 1 -1; -1 -1 1; -1 1 1]
    @test energy(spins(sg)) == energy(sg)

    # test that flip changes energy correctly and updates properly.
    flip!(sg, 3, 3)
    @test energy(spins(sg)) == -12
    energy!(sg)
    @test energy(sg) == -12
end

@testset "slice.jl" begin
    t = (10,10)
    ch = [
        'a' 'b' 'c' 'd' 'e'; 
        'f' 'g' 'h' 'i' 'j'; 
        'l' 'm' 'n' 'o' 'p'; 
        'q' 'r' 's' 't' 'u'; 
        'v' 'w' 'x' 'y' 'z'
    ]

    #corners
    @test slice(t, 1, 1) == (0, 2, 0, 2)
    @test slice(t, 10, 10) == (2, 0, 2, 0)
    @test slice(t, 1, 10) == (0, 2, 2, 0)
    @test slice(t, 10, 1) == (2, 0, 0, 2)

    #collumns
    @test slice(t, 2, 1) == (1, 2, 0, 2)
    @test slice(t, 2, 10) == (1, 2, 2, 0)
    @test slice(t, 3, 1) == (2, 2, 0, 2)
    @test slice(t, 3, 10) == (2, 2, 2, 0)

    #rows
    @test slice(t, 1, 2) == (0, 2, 1, 2)
    @test slice(t, 10, 2) == (2, 0, 1, 2)
    @test slice(t, 1, 3) == (0, 2, 2, 2)
    @test slice(t, 10, 3) == (2, 0, 2, 2)

    #near edges
    @test slice(t, 3, 2) == (2, 2, 1, 2)
    @test slice(t, 2, 3) == (1, 2, 2, 2)
    @test slice(t, 9, 8) == (2, 1, 2, 2)
    @test slice(t, 8, 9) == (2, 2, 2, 1)

    #inner corners
    @test slice(t, 2, 2) == (1, 2, 1, 2)
    @test slice(t, 9, 9) == (2, 1, 2, 1)
    @test slice(t, 2, 9) == (1, 2, 2, 1)
    @test slice(t, 9, 2) == (2, 1, 1, 2)

    #middle
    @test slice(t, 3, 3) == (2, 2, 2, 2)

    #correct central point of slice
    for i ∈ 1:5
        for j ∈ 1:5
            @test slice(ch,i,j)[slicecenter(ch,i,j)...] == ch[i,j]
        end
    end

end

@testset "Metropolis.jl" begin
    sg = SpinGrid(
        (5,5),
        map(ISpin, [1 0 0 0 1; 1 0 0 0 1; 0 1 1 1 0; 1 0 1 0 1; 1 1 0 1 0]),
        -24
    )

    for i ∈ 1:5
        for j ∈ 1:5
            flip!(sg, i, j)
            E = energy(spins(sg))
            flip!(sg, i, j)
            δ = E - -24
            @test ΔE(sg, i,j) == δ
        end
    end
    
end