"""
    iio_create_scan_context(backend, flags = 0)

Create a scan context.

# Parameters
- `backend::String` : 	A string containing a comma-separated list of the backend(s) to use for scanning.
- `flags::Cuint` :	    Unused for now. Set to 0.

# Returns
- on success, a pointer to a `iio_scan_context` structure
- On failure, an error is raised

NOTE:   Libiio version 0.20 and above can handle multiple strings,
        for instance "local:usb:", "ip:usb:", "local:usb:ip:",
        and require a colon as the delimiter. Libiio version 0.24
        and above prefer a comma instead of colon as the delimiter,
        and handle specifying backend-specific information. For instance,
         "local,usb=0456:*" will scan the local backend and limit scans on
        USB to vendor ID 0x0456, and accept all product IDs. The "usb=0456:b673"
        string would limit the scan to the device with this particular VID/PID.
        Both IDs are expected in hexadecimal, no 0x prefix needed.
"""
function iio_create_scan_context(backend::String, flags::Cuint = Cuint(0))
    _backend = isempty(backend) ? C_NULL : backend
    @check_null ccall((:iio_create_scan_context, libiio),
                      Ptr{iio_scan_context},
                      (Cstring, Cuint),
                      _backend, flags)
end

"""
    iio_scan_context_destroy(ctx)

Destroy the given scan context.

# Parameters
- `ctx::Ptr{iio_scan_context}` : A pointer to an `iio_scan_context`  structure

**NOTE:** After that function, the `iio_scan_context`  pointer shall be invalid.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga649d7821636c744753067e8301a84e6d)
"""
function iio_scan_context_destroy(ctx::Ptr{iio_scan_context})
    ccall((:iio_scan_context_destroy, libiio),
          Cvoid,
          (Ptr{iio_scan_context},),
          ctx)
end

"""
    iio_scan_context_get_info_list(ctx, info)

Enumerate available contexts.

# Parameters
- `ctx::Ptr{iio_scan_context}` : A pointer to an `iio_scan_context`  structure
- `info::Ref{Ptr{Ptr{iio_context_info}}}` : A pointer to a list of [`iio_context_info`](@ref) pointers.
                                            The pointed variable will be initialized on success.

# Returns
- On success, the number of contexts found.
- On failure, a negative error number.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga5d364d8d008bdbfe5486e6329d06257f)
"""
function iio_scan_context_get_info_list(ctx::Ptr{iio_scan_context},
                                        info::Ref{Ptr{Ptr{iio_context_info}}})
    return convert(Int,
                   ccall((:iio_scan_context_get_info_list, libiio),
                         Cssize_t,
                         (Ptr{iio_scan_context}, Ptr{Ptr{Ptr{iio_context_info}}}),
                         ctx, info))
end

"""
    iio_context_info_list_free(info)

Free a context info list.

# Parameters
- `info::Ptr{Ptr{iio_context_info}}` : A pointer to a [`iio_context_info`](@ref) pointer.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga4e618c6efb5a62e04a664f53f1b80d99)
"""
function iio_context_info_list_free(info::Ptr{Ptr{iio_context_info}})
    ccall((:iio_context_info_list_free, libiio),
          Cvoid,
          (Ptr{Ptr{iio_context_info}},),
          info)
end

"""
    iio_context_info_get_description(info)

Get a description of a discovered context.

# Parameters
- `Ptr{iio_context_info}`: A pointer to a [`iio_context_info`](@ref) structure.

# Returns
- A `String` containing the description.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga885558697d0e4dad11a4a5b6f5fbc4d6)
"""
function iio_context_info_get_description(info::Ptr{iio_context_info})
    return unsafe_string(ccall((:iio_context_info_get_description, libiio),
                               Cstring,
                               (Ptr{iio_context_info},),
                               info))
end

"""
    iio_context_info_get_uri(info)

Get the URI of a discovered context.

# Parameters
- `Ptr{iio_context_info}`: A pointer to a [`iio_context_info`](@ref) structure.

# Returns
- A `String` containing the URI.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga6a142a62112a0f84370d22facb2f2a37)
"""
function iio_context_info_get_uri(info::Ptr{iio_context_info})
    return unsafe_string(ccall((:iio_context_info_get_uri, libiio),
                               Cstring,
                               (Ptr{iio_context_info},),
                               info))
end

"""
    iio_create_scan_block(backend, flags = 0)

# Parameters
- `backend::String` : A string containing the backend to use for scanning. Can be empty
                      to use all available backends.
- `flags::Cuint` (optional) :  Unused for now. Set to 0.

# Returns
- on success, a pointer to an `iio_scan_block`  structure
- on failure, an error is raised

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#gad7fd2ea05bf5a8cebaff26b60edb8a13)
"""
function iio_create_scan_block(backend::String, flags::Cuint = Cuint(0))
    _backend = isempty(backend) ? C_NULL : backend
    return @check_null scan_block = ccall((:iio_create_scan_block, libiio),
                                          Ptr{iio_scan_block},
                                          (Cstring, Cuint),
                                          _backend, flags)
end

"""
    iio_scan_block_destroy(blk)

Destroy the given scan block.

# Parameters
- `blk::Ptr{iio_scan_block}` : A pointer to an `iio_scan_block`  structure

**NOTE:** After that function, the iio_scan_block pointer shall be invalid.

Introduced in version 0.20.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#ga91f6902ca18c491f96627cadb88c5c0a)
"""
function iio_scan_block_destroy(blk::Ptr{iio_scan_block})
    ccall((:iio_scan_block_destroy, libiio),
          Cvoid,
          (Ptr{iio_scan_block},),
          blk)
end

"""
    iio_scan_block_scan(blk)

Enumerate available contexts via scan block.

# Parameters
- `blk::Ptr{iio_scan_block}` : A pointer to an `iio_scan_block`  structure

# Returns
- On success, the number of contexts found.
- On failure, a negative error number.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Scan.html#gaee7e04572c3b4d202cd0043bb8cee642)
"""
function iio_scan_block_scan(blk::Ptr{iio_scan_block})
    return convert(Int,
                   ccall((:iio_scan_block, libiio),
                         Cssize_t,
                         (Ptr{iio_scan_block},),
                         blk))
end

"""
    iio_scan_block_get_info(blk, index)

Get the [`iio_context_info`](@ref) for a particular context.

# Parameters
- `blk::Ptr{iio_scan_block}` : A pointer to an `iio_scan_block`  structure
- `index::Cuint` : The index corresponding to the context.

# Returns
- A pointer to the [`iio_context_info`](@ref) for the context
- On success, a pointer to the specified [`iio_context_info`](@ref)
- On failure, an error is raised
"""
function iio_scan_block_get_info(blk::Ptr{iio_scan_block}, index::Cuint)
    return @check_null ccall((:iio_scan_block_get_info, libiio),
                             Ptr{iio_context_info},
                             (Ptr{iio_scan_block}, Cuint),
                             blk, index)
end
