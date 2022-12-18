using LibIIO, GLMakie
using Test

@testset "LibIIO.jl" begin
    # Write your tests here.
end

ctx = LibIIO.Context("ip:192.168.64.2")

dac = find_device(ctx, "dac_demo")
adc = find_device(ctx, "adc_demo")

dac_chn = find_channel(dac, "dac_out_ch0", true)
adc_chn = find_channel(adc, "adc_in_ch0")

enabled!(dac_chn, true)
enabled!(adc_chn, true)

dac_buf = LibIIO.Buffer(
    dac,
    400
)
##
y = round.(Int16, 10000*sin.(2π*1/400*(1:400)))

##
write(dac_buf, y)

LibIIO.push(dac_buf)

adc_buf = LibIIO.Buffer(
    adc,
    400
)
LibIIO.refill(adc_buf)

data = read(adc_buf)

d2 = reinterpret(Int16, data)

##
scatter(d2)
