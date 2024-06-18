using SpinLatticePhaseChanges
using Test

@testset "SpinLatticePhaseChanges.jl" begin
    # Write your tests here.
end

@testset "Spins" begin
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


@testset "SpinLattices" begin
    # Test SpinLattice struct
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

    @test size(sg) == (3,3)
    @test map(spin,spins(sg)) == [1 1 -1; -1 -1 1; -1 1 1]
    @test energy(spins(sg)) == energy(sg)

    # test that flip changes energy correctly and updates properly.
    flip!(sg, (3,3))
    @test energy(spins(sg)) == -12
    energy!(sg)
    @test energy(sg) == -12

end