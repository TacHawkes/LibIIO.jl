function iio_device_get_context(dev::Ptr{iio_device})
    return ccall((:iio_device_get_context, libiio),
                 Ptr{iio_context},
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_id(dev::Ptr{iio_device})
    return unsafe_string(ccall((:iio_device_get_id, libiio),
                               Cstring,
                               (Ptr{iio_device},),
                               dev))
end

function iio_device_get_name(dev::Ptr{iio_device})
    name = ccall((:iio_device_get_name, libiio),
                 Cstring,
                 (Ptr{iio_device},),
                 dev)
    return name != C_NULL ? unsafe_string(name) : ""
end

function iio_device_get_label(dev::Ptr{iio_device})
    label = ccall((:iio_device_get_label, libiio),
                  Cstring,
                  (Ptr{iio_device},),
                  dev)
    label != C_NULL ? unsafe_string(label) : ""
end

function iio_device_get_channels_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_channels_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_buffer_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_buffer_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_channel(dev::Ptr{iio_device}, index::Cuint)
    return @check_null ccall((:iio_device_get_channel, libiio),
                             Ptr{iio_channel},
                             (Ptr{iio_device}, Cuint),
                             dev, index)
end

function iio_device_get_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_get_buffer_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_buffer_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_find_channel(dev::Ptr{iio_device}, name::String, output::Bool)
    return @check_null ccall((:iio_device_find_channel, libiio),
                             Ptr{iio_channel},
                             (Ptr{iio_device}, Cstring, Cuchar),
                             dev, name, output)
end

function iio_device_find_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_find_buffer_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_buffer_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_attr_read(dev::Ptr{iio_device}, attr::String)
    attr == "" && (attr = C_NULL)
    dst = Vector{Cchar}(undef, BUF_SIZE)
    ret = ccall((:iio_device_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_device}, Cstring, Cstring, Csize_t),
                dev, attr, pointer(dst), BUF_SIZE)

    attr == C_NULL ? attrs = iio_parse_attr(dst, ret) : attrs = unsafe_string(pointer(dst))
    return ret, attrs
end

function iio_device_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_device_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

function iio_device_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

function iio_device_attr_write_raw(dev::Ptr{iio_device}, attr::String, src::Ptr{Cvoid},
                                   len::Csize_t)
    return ccall((:iio_device_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

function iio_device_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_device_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

function iio_device_attr_write_longlong(dev::Ptr{iio_device}, attr::String, val::Clonglong)
    return ccall((:iio_device_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

function iio_device_attr_write_double(dev::Ptr{iio_device}, attr::String, val::Cdouble)
    return ccall((:iio_device_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

function iio_device_buffer_attr_read(dev::Ptr{iio_device}, attr::String)
    attr == "" && (attr = C_NULL)
    dst = Vector{Cchar}(undef, BUF_SIZE)
    ret = ccall((:iio_device_buffer_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_device}, Cstring, Cstring, Csize_t),
                dev, attr, pointer(dst), BUF_SIZE)

    attr == C_NULL ? attrs = iio_parse_attr(dst, ret) : attrs = unsafe_string(pointer(dst))
    return ret, attrs
end

function iio_device_buffer_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                         data::Ptr{Cvoid})
    return ccall((:iio_device_buffer_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_buffer_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_buffer_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

function iio_device_buffer_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_buffer_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_buffer_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_buffer_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_buffer_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_buffer_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

function iio_device_buffer_attr_write_raw(dev::Ptr{iio_device}, attr::String,
                                          src::Ptr{Cvoid},
                                          len::Csize_t)
    return ccall((:iio_device_buffer_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

function iio_device_buffer_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                          data::Ptr{Cvoid})
    return ccall((:iio_device_buffer_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_buffer_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_buffer_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

function iio_device_buffer_attr_write_longlong(dev::Ptr{iio_device}, attr::String,
                                               val::Clonglong)
    return ccall((:iio_device_buffer_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

function iio_device_buffer_attr_write_double(dev::Ptr{iio_device}, attr::String,
                                             val::Cdouble)
    return ccall((:iio_device_buffer_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

function iio_device_set_data(dev::Ptr{iio_device}, data::Ptr{Cvoid})
    ccall((:iio_device_set_data, libiio),
          Cvoid,
          (Ptr{iio_device}, Ptr{Cvoid}),
          dev, data)
end

function iio_device_get_data(dev::Ptr{iio_device})
    return ccall((:iio_device_get_data, libiio),
                 Ptr{Cvoid},
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_trigger(dev::Ptr{iio_device})
    trigger = Ptr{iio_device}()
    ret = ccall((:iio_device_get_trigger, libiio),
                Cint,
                (Ptr{iio_device}, Ref{Ptr{iio_device}}),
                dev, Ref(trigger))
    return ret, trigger
end

function iio_device_set_trigger(dev::Ptr{iio_device}, trigger::Ptr{iio_device})
    return ccall((:iio_device_set_trigger, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{iio_device}),
                 dev, trigger)
end

function iio_device_is_trigger(dev::Ptr{iio_device})
    return convert(Bool,
                   ccall((:iio_device_is_trigger, libiio),
                         Cuchar,
                         (Ptr{iio_device},),
                         dev))
end

function iio_device_set_kernel_buffers_count(dev::Ptr{iio_device}, nb_buffers::Cuint)
    return ccall((:iio_device_set_kernel_buffers_count, libiio),
                 Cint,
                 (Ptr{iio_device}, Cuint),
                 dev, nb_buffers)
end
