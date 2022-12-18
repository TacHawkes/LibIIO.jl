function iio_buffer_get_device(buffer::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_device, libiio),
                 Ptr{iio_device},
                 (Ptr{iio_device},),
                 buffer)
end

function iio_device_create_buffer(dev::Ptr{iio_device}, samples_count::Csize_t,
                                  cyclic::Bool)
    return @check_null ccall((:iio_device_create_buffer, libiio),
                             Ptr{iio_buffer},
                             (Ptr{iio_device}, Csize_t, Cuchar),
                             dev, samples_count, cyclic)
end

function iio_buffer_destroy(buf::Ptr{iio_buffer})
    ccall((:iio_buffer_destroy, libiio),
          Cvoid,
          (Ptr{iio_buffer},),
          buf)
end

function iio_buffer_get_poll_fd(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_poll_fd, libiio),
                 Cint,
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_set_blocking_mode(buf::Ptr{iio_buffer}, blocking::Bool)
    return ccall((:iio_buffer_set_blocking_mode, libiio),
                 Cint,
                 (Ptr{iio_buffer}, Cuchar),
                 buf, blocking)
end

function iio_buffer_refill(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_refill, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_push(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_push, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_push_partial(buf::Ptr{iio_buffer}, samples_count::Csize_t)
    return ccall((:iio_buffer_push_partial, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer}, Csize_t),
                 buf, samples_count)
end

function iio_buffer_cancel(buf::Ptr{iio_buffer})
    ccall((:iio_buffer_cancel, libiio),
          Cvoid,
          (Ptr{iio_buffer},),
          buf)
end

function iio_buffer_start(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_start, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_first(buf::Ptr{iio_buffer}, chn::Ptr{iio_channel})
    return ccall((:iio_buffer_first, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_channel}, Ptr{iio_channel}),
                 buf, chn)
end

function iio_buffer_step(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_step, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_end(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_end, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_buffer},),
                 buf)
end

function iio_buffer_foreach_sample(buf::Ptr{iio_buffer}, callback::Ptr{Cvoid},
                                   data::Ptr{Cvoid})
    return ccall((:iio_buffer_foreach_sample, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer}, Ptr{Cvoid}, Ptr{Cvoid}),
                 buf, callback, data)
end

function iio_buffer_set_data(buf::Ptr{iio_buffer}, data)
    return ccall((:iio_buffer_set_data, libiio),
                Cvoid,
                (Ptr{iio_buffer}, Ptr{Cuchar}),
                buf, data
    )
end

function iio_buffer_get_data(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_data, libiio),
                Ptr{iio_device},
                (Ptr{iio_buffer},),
                buf
    )
end
