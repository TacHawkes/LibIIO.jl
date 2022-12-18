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
