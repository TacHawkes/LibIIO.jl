```@meta
CurrentModule = LibIIO
```

# [Introduction](@id clib-index)

The package wraps all of the libiio C-functions in Julia functions with the same name. You can load them into your current namespace with

```julia
using LibIIO.CLibIIO
```

Usage of these low-level functions is recommended for advanced users who are familiar with the inner workings of iio/libiio.
Please not that while the provided functions are _almost_ identical to their C counterparts, they have been modified for some convenience.
All functions working with char pointers, take Julia Strings as their inputs and also return Julia strings if the C function would require a modifiable
C-pointer. Furthermore, most functions requiring pointers (e.g. buffers) to be passed to the C function will create them within the wrapper and return
a Julia-type to the user with the value instead. This requires a bit more allocations but in turn you do not have to take care of pointers and garbage collection issues.

```@index
Pages = ["cindex.md"]
```

```@autodocs
Modules = [LibIIO.CLibIIO]
Pages = ["ctypes.jl"]
```