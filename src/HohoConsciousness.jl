# Package entrypoint.
#
# The pre-0.3 implementation is preserved byte-for-byte in
# HohoConsciousnessCore.jl. Additional experimental layers are loaded into the
# already-defined HohoConsciousness module so the core model can stay unchanged.
#
# This file is evaluated by Julia's package loader before HohoConsciousness has
# imported Base into its own module scope, so use Base.include explicitly here.

Base.include(@__MODULE__, "HohoConsciousnessCore.jl")
Base.include(getfield(@__MODULE__, :HohoConsciousness), "ImaginaryMode.jl")
