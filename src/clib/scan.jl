"""
    iio_create_scan_context(backend, flags = 0)

Create a scan context.

# Parameters
- `backend::String` : 	A string containing a comma-separated list of the backend(s) to use for scanning.
- `flags::Cuint` :	    Unused for now. Set to 0.

# Returns
- on success, a pointer to a iio_scan_context structure
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
    @check_null ccall((:iio_create_scan_context, libiio),
                      Ptr{iio_scan_context},
                      (Cstring, Cuint),
                      backend, flags)
end

function iio_scan_context_destroy(ctx::Ptr{iio_scan_context})
    ccall((:iio_scan_context_destroy, libiio),
          Cvoid,
          (Ptr{iio_scan_context},),
          ctx)
end

function iio_scan_context_get_info_list(ctx::Ptr{iio_scan_context},
                                        info::Ref{Ptr{Ptr{iio_context_info}}})
    return convert(Int,
                   ccall((:iio_scan_context_get_info_list, libiio),
                         Cssize_t,
                         (Ptr{iio_scan_context}, Ptr{Ptr{Ptr{iio_context_info}}}),
                         ctx, info))
end

function iio_context_info_list_free(info::Ptr{Ptr{iio_context_info}})
    ccall((:iio_context_info_list_free, libiio),
          Cvoid,
          (Ptr{Ptr{iio_context_info}},),
          info)
end

function iio_context_info_get_description(info::Ptr{iio_context_info})
    return unsafe_string(ccall((:iio_context_info_get_description, libiio),
                               Cstring,
                               (Ptr{iio_context_info},),
                               info))
end

function iio_context_info_get_uri(info::Ptr{iio_context_info})
    return unsafe_string(ccall((:iio_context_info_get_uri, libiio),
                               Cstring,
                               (Ptr{iio_context_info},),
                               info))
end

function iio_create_scan_block(backend::String, flags::Cuint)
    return @check_null scan_block = ccall((:iio_create_scan_block, libiio),
                                          Ptr{iio_scan_block},
                                          (Cstring, Cuint),
                                          backend, flags)
end

function iio_scan_block_destroy(blk::Ptr{iio_scan_block})
    ccall((:iio_scan_block_destroy, libiio),
          Cvoid,
          (Ptr{iio_scan_block},),
          blk)
end

function iio_scan_block_scan(blk::Ptr{iio_scan_block})
    return convert(Int,
                   ccall((:iio_scan_block, libiio),
                         Cssize_t,
                         (Ptr{iio_scan_block},),
                         blk))
end

function iio_scan_block_get_info(blk::Ptr{iio_scan_block}, index::Cuint)
    return @check_null ccall((:iio_scan_block_get_info, libiio),
                             Ptr{iio_context_info},
                             (Ptr{iio_scan_block}, Cuint),
                             blk, index)
end
