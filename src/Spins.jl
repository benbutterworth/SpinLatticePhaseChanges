export Spin, ISpin, XYSpin
export spin, flip, nudge

#======================= ABSTRACT & CONCRETE SPIN TYPES =======================#
abstract type Spin end

"""
    ISpin <: Spin
1D Spin type. Can be oriented ↑ (spin=true) or ↓ (spin=false). 
"""
struct ISpin <: Spin
    spin::Bool #spin up or down
end

"""
    XYSpin <: Spin
2D Spin type. Can be oriented by any angle 0 ≤ θ ≤ 2π.
"""
struct XYSpin <: Spin
    spin::Float64
    function XYSpin(f::Float64)
        s = mod(f, 2π)
        new(s)
    end
end

#====================== ACCESSOR & CONSTRUCTOR FUNCTIONS ======================#
spin(s::ISpin) = ifelse(s.spin, 1, -1)
spin(s::XYSpin) = s.spin

ISpin() = ISpin(true)

"""
    ISpin(r::AbstractFloat, p::AbstractFloat=0.5)
Return a random spin pointing ↑ with probability _p_.
"""
function ISpin(r::AbstractFloat, p::AbstractFloat=0.5)
    # r = random number, p = probability threshold
    if r < p
        ISpin(true)
    else
        ISpin(false)
    end
end

XYSpin() = XYSpin(0.0)
#
#  CONCEPTUAL ISSUE - HOW CAN YOU CREATE A RANDOM UNIT POLAR VECTOR WITH IT'S
#	DIRECTION WEIGHTED TOWARDS A CERTAIN POLAR UNIT VECTOR, ̄r?
#

#============================== TYPE CONVERSIONS ==============================#
XYSpin(s::ISpin) = ifelse(s.spin, XYSpin(0.0), XYSpin(Float64(π)))
function ISpin(s::XYSpin)
    # Anything above ↔ snaps to ↑ & visa versa 
    if π / 2 < spin(s) ≤ 3π / 2
        ISpin(false)
    elseif 0 ≤ spin(s) ≤ π / 2 || 3π / 2 < spin(s) <= 2π
        ISpin(true)
    else
        err = DomainError(s.spin, "angle out of bounds 0 < θ ≤ 2π")
        throw(err)
    end
end

convert(::Type{ISpin}, s::XYSpin) = ISpin(s)
convert(::Type{XYSpin}, s::ISpin) = XYSpin(s)

#======================== DEFINING ARITHMETIC ON SPINS ========================#
+(a::ISpin, b::ISpin) = spin(a) + spin(b)
-(a::ISpin, b::ISpin) = spin(a) - spin(b)
*(a::ISpin, b::ISpin) = spin(a) * spin(b)

+(a::XYSpin, b::XYSpin) = mod(spin(a) + spin(b), 2π)
-(a::XYSpin, b::XYSpin) = mod(spin(a) - spin(b), 2π)

"""
    *(a::XYSpin, b::XYSpin)
Return the magnitude of the overlap in the same direction between spins _a_ & _b_.
"""
function *(a::XYSpin, b::XYSpin)
    # Dot product of 2 unit polar vectors
    θ, ϕ = map(spin, [a, b])
    cos(θ) * cos(ϕ) + sin(θ) * sin(ϕ)
end

promote_rule(::Type{ISpin}, ::Type{XYSpin}) = XYSpin
+(θ::Spin, ϕ::Spin) = +(promote(θ, ϕ)...)
-(θ::Spin, ϕ::Spin) = -(promote(θ, ϕ)...)
*(θ::Spin, ϕ::Spin) = *(promote(θ, ϕ)...)

#============================== DISPLAYING SPINS ==============================#
function show(io::IO, s::ISpin)
    print(io, ifelse(s.spin, '↑', '↓'))
end

function show(io::IO, s::XYSpin)
    if π / 4 <= spin(s) < 3π / 4
        print(io, '→')
    elseif 3π / 4 <= spin(s) < 5π / 4
        print(io, '↓')
    elseif 5π / 4 <= spin(s) < 7π / 4
        print(io, '←')
    elseif 7π / 4 <= spin(s) < 2π || 0 <= spin(s) < π < 4
        print(io, '↑')
    else
        print(io, '█')
    end
end

#================================= FLIP A SPIN ================================#
"""
    flip(s::ISpin)
Return a spin pointing in the opposite direction to _s_.
"""
function flip(s::ISpin)
    ISpin(!s.spin)
end

"""
    flip(s::XYSpin)
Return a spin pointing in the opposite direction to _s_.
"""
function flip(s::XYSpin)
    XYSpin(s.spin + π)
end

"""
    nudge(s::XYSpin, θ::Real)
Return a spin rotated by θ rad compared to spin _s_.
"""
function nudge(s::XYSpin, θ::Real)
    θ = convert(Float64, θ)
    XYSpin(spin(s) + θ)
end