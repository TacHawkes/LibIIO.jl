"""
    iio_library_get_version()

Get the version of the libiio library.

# Returns
- `major::UInt` : The major version
- `minor::UInt` : The minor version
- `git_tag::String` : The version's git tag

See: [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__TopLevel.html#gaaa29e5bac86d00a1cef6e2d00b0ea24c)
"""
function iio_library_get_version()
    major, minor, git_tag = Ref{Cuint}(0), Ref{Cuint}(0), Vector{Cchar}(undef, 8)
    ccall((:iio_library_get_version, libiio),
          Cvoid,
          (Ref{Cuint}, Ref{Cuint}, Ptr{Cchar}),
          major, minor, pointer(git_tag))

    return UInt(major[]), UInt(minor[]), unsafe_string(pointer(git_tag))
end

"""
    iio_strerror(err)

Get a string description of an error code.

# Parameters
- `err::Int` : The error code

# Returns
- `dst::String` : The string description of the error

See: [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__TopLevel.html#ga4a117b0ac02e97aeda92e33c063f7cf0)
"""
function iio_strerror(err::Cint)
    dst = Vector{Cchar}(undef, 256)
    ccall((:iio_strerror, libiio),
          Cvoid,
          (Cint, Ptr{Cchar}, Csize_t),
          err, pointer(dst), length(dst))

    return unsafe_string(pointer(dst))
end

"""
    iio_has_backend(backend)

Check if the specified backend is available.

# Parameters
- `backend::String` : The name of the backend to query

# Returns
- True if the backend is available, false otherwise

See: [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__TopLevel.html#ga8cf6a3818d471333f4115f3d0d8d95a2)
"""
function iio_has_backend(backend::String)
    return convert(Bool,
                   ccall((:iio_has_backend, libiio),
                         Cuchar,
                         (Cstring,),
                         backend))
end

"""
    iio_get_backends_count_count()

Get the number of available backends.

# Returns
- The number of available backends

See: [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__TopLevel.html#gabe08d9f1e10801b0334575063a66a56c)
"""
function iio_get_backends_count()
    return ccall((:iio_get_backends_count, libiio),
                 Cuint, ())
end

"""
    iio_get_backend(index)

Retrieve the name of a given backend.

# Parameters
- `index` : The index corresponding to the attribute

# Returns:
- On success, a string containing the backend
- If the index is invalid, an empty string is returned

See: [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__TopLevel.html#ga0b950d578c5e4e06232949159c491dab)
"""
function iio_get_backend(index::Cuint)
    out = ccall((:iio_get_backend, libiio),
                Cstring,
                (Cuint,),
                index)

    return out != C_NULL ? unsafe_string(out) : ""
end
iio_get_backend(index::Int) = iio_get_backend(convert(Cuint, index))
