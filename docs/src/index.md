```@meta
CurrentModule = LibIIO
```

# LibIIO

LibIIO.jl provides Julia bindings for [libiio](https://wiki.analog.com/resources/tools-software/linux-software/libiio) which is a library for interfacing with Linux industrial I/O devices. This packages is meant to give you an easy-to-use high-level API interface matching the [Python-bindings](https://github.com/analogdevicesinc/libiio/tree/master/bindings/python) with some adaptions to Julia-specifics. If you prefer to work directly with libiio, all C-functions are exposed (but not exported) as a Julia function matching the C functions exactly in name. These function mostly match their C-counterparts but have some added convenience around them and convert their results to Julia types where applicable.

# Installation

Install the packing using the package manager with:

```julia
] add LibIIO
```

# Usage

There are two ways to use this package:

1. If you want an easy experience, almost identical to the libiio Python bindings, use the high-level wrappers for the IIO concepts, like contexts, devices, channels, buffers and attributes. You will be only using Julia types and do not have to deal with the C pointers and C data types. See the [IIO Demo](@ref iio_demo) page for an example.
2. If you are well familiar with the C libary, this package wraps all libiio C functions an exposes them with exactly the same names. However, they are not eported by `using LibIIO`. You must address them by prefixing them with the package name or load them explicitly by writing `using LibIIO.CLibIIO`. See the [low-level documentation](@ref clib-index) pages for further documentation. The documentation is mainly copied over (and linked) from the original C-library documentation but there are small adaptions for easier use of the library in Julia. Therefore it is recommend to read the docs of this package.

# Libiio 1.0

In the near future [libiio 1.0](https://www.youtube.com/watch?v=Y7JhEeWma_s) will be released with libiio 0.24 being the last 0.x release. The new version will have some (partially breaking) changes to the buffer interface, which will also affect language bindings. There will be a compatibility layer for libiio so that 0.x and 1.x version will be up-/downwards compatible. When libiio 1.0 is released, these bindings will be updated to the new interface. If you want to have a look, what will be coming, you can checkout the updated Python bindings on the `dev` branch of libiio: <https://github.com/analogdevicesinc/libiio/blob/dev/bindings/python/iio.py>