#=

This examples assumes that the IIO Demo application is installed on a linux host.
Find details here: https://wiki.analog.com/resources/eval/user-guides/iio_demo/no-os-setup

A simple signal is sent to the virtual DAC device which is looped back into the virtual ADC.
This shows how to use buffers for high-speed data transfer.

=#

using LibIIO

# Adjust to your settings
uri = "ip:192.168.64.2"

# create context
ctx = Context(uri)

# get both device handles by their name
dac = find_device(ctx, "dac_demo")
adc = find_device(ctx, "adc_demo")

# get both channels (adc/dac)
dac_chn = find_channel(dac, "dac_out_ch0", true)
adc_chn = find_channel(adc, "adc_in_ch0")

# enable the channels
enabled!(dac_chn, true)
enabled!(adc_chn, true)

# create DAC buffer with 400 samples
dac_buf = Buffer(dac, 400)

# create the ADC buffer for reading
adc_buf = Buffer(adc, 400)

# dummy signal to feed into the DAC and read back using the ADC
y = round.(Int16, 10000*sin.(2π*1/200*(1:400)))

# write the test signal into the buffer
write(dac_buf, y)

# push the buffer to the hardware
push(dac_buf)

# Read samples from the ADC hardware into the buffer
refill(adc_buf)

# Retrieve the samples from the buffer
data = read(adc_buf)

# Reinterpret as Int16, the actual sample format
d2 = reinterpret(Int16, data)

# Verify that the read signal matches the original signal
if all(d2 .== y)
    @info "Loopback successful"
else
    @error "Loopback failed"
end


##
atr = attrs(adc_chn)["adc_channel_attr"]

ret, v = read(atr)
