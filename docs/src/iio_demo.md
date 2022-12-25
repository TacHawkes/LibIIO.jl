# Setting up the libiio and the IIO demo project

For this example you need a linux system with [libiio](https://wiki.analog.com/resources/tools-software/linux-software/libiio) installed. Many distros have a bundled package. If you prefer to build it from source, you can follow this [build guide](https://wiki.analog.com/resources/tools-software/linux-software/libiio#building_on_the_linux_host_target).

If you want to setup a sandbox for testing IIO, using [multipass](https://multipass.run) (she knows it's a multipass) is a quick way to set up an Ubuntu VM where the IIO demo project can be installed.

The IIO demo project is a small demo of the IIO framework where a 16 bit ADC and a 16 bit DAC is simulated with buffer support. With default settings there is a loopback between DAC/ADC, i.e. data you send to the DAC is piped back into the ADC.

Furthermore you need to build the [IIO Demo](https://wiki.analog.com/resources/eval/user-guides/iio_demo/no-os-setup). This can be done with these stepse:

1. Clone the `no-os` git repostitory from Analog Devices:
```bash
git clone --recursive https://github.com/analogdevicesinc/no-OS
```
2. Enter into the projects folder with 
```bash
cd no-OS/projects/iio_demo
```
3. Compile the demo project using 
```bash
make PLATFORM = linux
```
4. Execute the demo project using 
```bash
./build/iio_demo.out
```

Now you can use the demo devices either on the same system or from a different system. If you use another system you need to have a network connection between these two systems.

# Using LibIIO.jl with the IIO demo devices

This example will send a sine wave signal to the DAC device using buffers and reads the signal back using the ADC device with another buffer and checks that data is identical.

Create a new Julia environment with `LibIIO.jl` installed as package. Then create a new julia file and load the package with

```julia
using LibIIO
```

Now we try to connect with the IIO daemon using the network context. This is done the following way:

```julia
uri = "ip:192.168.64.2"
ctx = Context(uri)
```

!!! note
    Do not forget to change the IP address to your settings. For a local connection use `127.0.0.1`.

This should print the details of the context (attributes, devices, channels etc.) on the REPL console like this:

```
IIO context created with network backend.
Backend version: 1.1 (git tag: 0000000)
Backend description string: 192.168.64.2 no-OS analog 1.1.0-g0000000 #1 Tue Nov 26 09:52:32 IST 2019 armv7l
IIO context has 3 attributes:
        no-OS: 1.1.0-g0000000
        ip,ip-addr: 192.168.64.2
        uri: ip:192.168.64.2
IIO context has 2 devices:
        iio:device0: adc_demo (buffer capable)
                2 channels found:
                        voltage0: adc_in_ch0 (input, index: 0, format: le:S16/16>>0)
                        1 channel-specific attributes found:
                                attr 0: adc_channel_attr value: 1111
                        voltage1: adc_in_ch1 (input, index: 1, format: le:S16/16>>0)
                        1 channel-specific attributes found:
                                attr 0: adc_channel_attr value: 1112
                1 device-specific attributes found:
                                attr 0: adc_global_attr value: 3333
                1 debug-specific attributes found:
                                attr 0: direct_reg_access value: 0
ERROR: checking for trigger : Invalid argument (22)
        iio:device1: dac_demo (buffer capable)
                2 channels found:
                        voltage0: dac_out_ch0 (output, index: 0, format: le:S16/16>>0)
                        1 channel-specific attributes found:
                                attr 0: dac_channel_attr value: 1111
                        voltage1: dac_out_ch1 (output, index: 1, format: le:S16/16>>0)
                        1 channel-specific attributes found:
                                attr 0: dac_channel_attr value: 1112
                1 device-specific attributes found:
                                attr 0: dac_global_attr value: 4444
                1 debug-specific attributes found:
                                attr 0: direct_reg_access value: 0
ERROR: checking for trigger : Invalid argument (22)
```

!!! info
    Do not worry about the errors. This demo is built without trigger support, therefore the error message is actually correct.

The context has two devices, called `adc_demo` and `dac_demo`. It would be also possible to address them using their IDs `iio:device0` and `iio:devic1` instead of their names. To retrieve a device handle we use the code:

```julia
dac = find_device(ctx, "dac_demo")
adc = find_device(ctx, "adc_demo")
```

Now we need to get a handle to the channel of each device respectively. Note that for the DAC, the argument `is_output` of the [`find_channel`](@ref) function has to be set to `true`. The demo devices each have two channels, we use only the first channel (`voltage0`). The channels are named `adc_in_ch0` and `dac_out_ch0` for this example.

```julia
dac_chn = find_channel(dac, "dac_out_ch0", true)
adc_chn = find_channel(adc, "adc_in_ch0")
```

Before creating a buffer for writing/reading channels, the channels have to be enabled:

```julia
enabled!(dac_chn, true)
enabled!(adc_chn, true)
```

In the next step a buffer for each device for 400 samples is set up.

```julia
dac_buf = Buffer(dac, 400)
adc_buf = Buffer(adc, 400)
```

!!! warning
    The buffer creation can be done only once, otherwise a "busy"-error will be issued.
    The buffer object should be stored savely. If you delete the buffer (e.g. with `dac_buf = nothing`)
    the Julia garbage collector does not run immediately (you can explicitly run it with `GC.gc()`) and so the C-pointer and connected ressources are not freed immediately. In general `LibIIO.jl` tries to properly cleanup the C-pointers using the libiio `destroy` functions but due to the nature of the garbage collector this is not done immediately upon deleting the Julia references to the objects.

For the sake of this example, we now generate 400 samples of a sine wave with two full periods:

```julia
y = round.(Int16, 10000*sin.(2π*1/200*(1:400)))
```

This data can now be written to the `dac_buffer` object which just copies the data into the buffer's memory but this memory is still on the host computer and not on the physical device. This transfer to the device is issued by calling the [`push`](@ref) function on the buffer.

```julia
write(dac_buffer, y)
push(dac_buffer)
```

For a real device the data would be physically sent to the DAC device and would be measurable as an analog signal (i.e. using an oscilloscope). In this demo the data can be immediately read back using the ADC device.

First we have to issue the physical transfer from the ADC device to the buffer memory and then read the data into a Julia variable:

```julia
refill(adc_buf)
data = read(adc_buf)
```

The data is returned as bytes, so for our 16 bit ADC/DAC devices we will receive 800 bytes of data when sending/requestion 400 samples. The data is returned as `Cuchar`/`UInt8` and has to be reinterpreted to the device sample format:

```
d2 = reinterpret(Int16, data)
```

!!! note
    In general this can be way more complex depending on the device. `iio_info` or using this package you get an info string for each channel which tells you how to interpret the raw binary data from the device. In this example the ADC channel has the info `voltage0: adc_in_ch0 (input, index: 0, format: le:S16/16>>0)`. The `format` part tells you that this device transmit in little Endian format (the library takes care of conversion when not using the `raw` mode) and signed 16 bit samples are transfered where the full 16 bits represent one sample, so a right-shift of zero (i.e. no shift at all) is required to interpet the sample. You can get a structured information of the data format of a channel using the [`data_format`](@ref LibIIO.data_format) function. This function will also give you a scaling factor, i.e. for temperature sensors where the integer data has to be scale to a float value.

Now the variable `d2` contains the samples read from the ADC in the correct format. To check if this matches our original signal in `y` you can use:

```julia
if all(d2 .== y)
    @info "Loopback successful"
else
    @error "Loopback failed"
end
```

# The full example

```julia
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
dac_buf = Buffer(
    dac,
    400
)

# create the ADC buffer for reading
adc_buf = Buffer(
    adc,
    400
)

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
```