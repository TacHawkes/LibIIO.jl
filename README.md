# LibIIO.jl

LibIIO.jl provides Julia bindings for [libiio](https://wiki.analog.com/resources/tools-software/linux-software/libiio) which is a library for interfacing with Linux industrial I/O devices. This packages is meant to
give you an easy-to-use high-level API interface matching the [Python-bindings](https://github.com/analogdevicesinc/libiio/tree/master/bindings/python) with some adaptions to Julia-specifics. If you prefer to work directly with libiio, all C-functions are exposed (but not exported) as a Julia function matching the C functions exactly in name. These function mostly match their C-counterparts but have some added convenience around them and convert their results to Julia types where applicable.

## Documentation

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tachawkes.github.io/LibIIO.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tachawkes.github.io/LibIIO.jl/dev/)

## Installation

Install the package using:

```julia
] add LibIIO
```

## Example

The package prints information about the objects in the same fashion as `iio_info` does. For example, if you have the [IIO Demo](https://wiki.analog.com/resources/eval/user-guides/iio_demo/no-os-setup) installed, you can connect to the IIO network context using:

```julia
using LibIIO

# Adjust to your settings
uri = "ip:127.0.0.1"

# Connect to the context using the network backend.
ctx = Context(uri)
```

This will print (note, that the trigger errors are correct here!):

```
IIO context created with network backend.
Backend version: 1.1 (git tag: 0000000)
Backend description string: 127.0.0.1 no-OS analog 1.1.0-g0000000 #1 Tue Nov 26 09:52:32 IST 2019 armv7l
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

See the examples folder for more details or the documentation.

## Similar packages

The [AdalmPluto.jl](https://github.com/JuliaTelecom/AdalmPluto.jl) package is focussed on just interfacing an [AdalmPluto](https://www.analog.com/en/design-center/evaluation-hardware-and-software/evaluation-boards-kits/adalm-pluto.html) but actually has a quite complete libiio implementation in its internals. Actually this package uses their libiio_jll package (Kudos for that!) to provide the C binaries. However, that package is not focussed on exposing the libiio API and only gives low-level access.