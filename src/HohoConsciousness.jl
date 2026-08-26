# Package entrypoint.
#
# The pre-0.3 implementation is preserved byte-for-byte in
# HohoConsciousnessCore.jl.  Additional experimental layers are loaded into the
# already-defined HohoConsciousness module so the core model can stay unchanged.

include("HohoConsciousnessCore.jl")
Base.include(HohoConsciousness, joinpath(@__DIR__, "ImaginaryMode.jl"))
