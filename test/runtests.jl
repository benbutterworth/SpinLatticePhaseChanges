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
    s = [s1, s2, s3]

    @test map(spin, s) == [0, π / 2, 3π / 2]
    @test s1 + s2 == spin(s2)
    @test s2 + s3 == spin(s1)
    @test s2 - s3 == s3 - s2 == Float64(π)
    @test XYSpin(ISpin()) == s1
    @test ISpin(s2) == ISpin()
    @test ISpin(s3) == ISpin(false)
    @test flip(s2) == s3
    @test flip(s3) == s2
    @test map(x -> nudge(x, π), s) == map(flip, s)
end


@testset "SpinLattices.jl" begin
    # Test SpinLattice structs
    spingrid = SpinGrid(
        map(ISpin, [0 0 0 0 0; 0 0 1 1 0; 1 1 1 0 0; 1 0 0 0 1; 0 1 0 0 1])
    )
    s = SpinGrid(100, 100, 1.0)

    @test size(spingrid) == (5,5)
    @test map(spin, spins(spingrid)) == [-1 -1 -1 -1 -1; -1 -1 1 1 -1; 1 1 1 -1 -1; 1 -1 -1 -1 1; -1 1 -1 -1 1] 

    # test that flip changes energy correctly and updates properly.
    spintest = spingrid[3,3]
    flip!(spingrid, 3, 3)
    @test spintest == flip(spingrid[3,3])

    @test sum(spin, spins(s)) == 100^2
end

@testset "segment.jl" begin
    t = (10, 10)
    ch = [
        'a' 'b' 'c' 'd' 'e';
        'f' 'g' 'h' 'i' 'j';
        'l' 'm' 'n' 'o' 'p';
        'q' 'r' 's' 't' 'u';
        'v' 'w' 'x' 'y' 'z'
    ]

    #corners
    @test SpinLatticePhaseChanges.segmentsize(t, 1, 1) == (0, 2, 0, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 10, 10) == (2, 0, 2, 0)
    @test SpinLatticePhaseChanges.segmentsize(t, 1, 10) == (0, 2, 2, 0)
    @test SpinLatticePhaseChanges.segmentsize(t, 10, 1) == (2, 0, 0, 2)

    #collumns
    @test SpinLatticePhaseChanges.segmentsize(t, 2, 1) == (1, 2, 0, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 2, 10) == (1, 2, 2, 0)
    @test SpinLatticePhaseChanges.segmentsize(t, 3, 1) == (2, 2, 0, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 3, 10) == (2, 2, 2, 0)

    #rows
    @test SpinLatticePhaseChanges.segmentsize(t, 1, 2) == (0, 2, 1, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 10, 2) == (2, 0, 1, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 1, 3) == (0, 2, 2, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 10, 3) == (2, 0, 2, 2)

    #near edges
    @test SpinLatticePhaseChanges.segmentsize(t, 3, 2) == (2, 2, 1, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 2, 3) == (1, 2, 2, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 9, 8) == (2, 1, 2, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 8, 9) == (2, 2, 2, 1)

    #inner corners
    @test SpinLatticePhaseChanges.segmentsize(t, 2, 2) == (1, 2, 1, 2)
    @test SpinLatticePhaseChanges.segmentsize(t, 9, 9) == (2, 1, 2, 1)
    @test SpinLatticePhaseChanges.segmentsize(t, 2, 9) == (1, 2, 2, 1)
    @test SpinLatticePhaseChanges.segmentsize(t, 9, 2) == (2, 1, 1, 2)

    #middle
    @test SpinLatticePhaseChanges.segmentsize(t, 3, 3) == (2, 2, 2, 2)

    #correct central point of segment
    for i ∈ 1:5
        for j ∈ 1:5
            @test segment(ch, i, j)[SpinLatticePhaseChanges.segmentcenter(ch, i, j)...] == ch[i, j]
        end
    end

end


#
# ALL WILL FAIL AS OF 24-06-24
#
@testset "Metropolis.jl" begin
    spingrid = SpinGrid(
        map(ISpin, [1 0 0 0 1; 1 0 0 0 1; 0 1 1 1 0; 1 0 1 0 1; 1 1 0 1 0]),
    )
end