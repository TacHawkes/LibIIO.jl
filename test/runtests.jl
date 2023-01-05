using LibIIO
using Test

# As libiio does not have tests or a test mode, this package is hardly testable as
# most of the calls end up in a ccall immediately...

@testset "LibIIO.jl" begin
    @test_nowarn LibIIO._get_library_version()
end
