using SpinLatticePhaseChanges
using Test

@testset "SpinLatticePhaseChanges.jl" begin
    # Write your tests here.
end

@testset "ISpins" begin
    # Initialisation ISpin
    s1 = ISpin()
    s2 = ISpin(false)

    @test spin(s1) == 1 && spin(s2) == -1

    @test s1+s2 == 0
    @test s1+s1 == 2
    @test s2+s2 == -2

    @test s1-s2 == 2

    @test s1*s2 == -1

    @test flip(s2) == s1
end

@testset "ISpins" begin
    # Initialisation ISpin
    s1 = XYSpin()
    s2 = XYSpin(π/2)
    s3 = XYSpin(3π/2)

    @test spin(s2) == π/2

    @test s1+s2 == s2
    @test s2+s3 == s1

    @test s2-s3 == s3 - s2 == XYSpin(π)

    @test XYSpin(ISpin()) = s1
    
    @test flip(s2) == s3
    @test flip(s3) == s2
end


@testset "SpinLattices" begin
    # Test SpinLattice struct
end