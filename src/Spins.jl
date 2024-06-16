#==============================================================================#
#                                   SPINS.JL                                   #
#==============================================================================#
#  a second, more programmatic, attempt to create a spin class
#
#   REVISIONS:
#     Date       Version                         Changes
#   ========    =========  ====================================================
#   11/06/24       0.0     
#==============================================================================#
#==============================================================================#

export ISpin, XYSpin, spin, flip, nudge

import Base: +, -, *, /, show, convert, promote_rule

#======================= ABSTRACT & CONCRETE SPIN TYPES =======================#
abstract type Spin end

struct ISpin <: Spin
    spin::Bool #spin up or down
end

struct XYSpin <: Spin
    spin::Float16
end

struct NullSpin <: Spin end

#====================== ACCESSOR & CONSTRUCTOR FUNCTIONS ======================#
spin(s::ISpin) = ifelse(s.spin, 1, -1)
spin(s::XYSpin) = s.spin

ISpin() = ISpin(true)
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
XYSpin(s::ISpin) = ifelse(s.spin, XYSpin(0), XYSpin(π))
function ISpin(s::XYSpin)
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

+(a::XYSpin, b::XYSpin) = spin(a) + spin(b) % 2π
-(a::XYSpin, b::XYSpin) = spin(a) - spin(b) + 2π % 2π
function *(a::XYSpin, b::XYSpin)
    # Dot product of 2 unit polar vectors
    cos(spin(a)) * cos(spin(b)) + sin(spin(a)) * sin(spin(b))
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
function flip(s::ISpin)
    ISpin(!s.spin)
end

function flip(s::XYSpin)
    XYSpin(s.spin + π % 2π)
end

function nudge(s::XYSpin, θ::Float16)
    XYSpin(spin(s) + θ % 2π)
end