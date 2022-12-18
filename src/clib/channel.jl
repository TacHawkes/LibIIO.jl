function iio_channel_get_device(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_device, libiio),
                 Ptr{iio_device},
                 (Ptr{iio_channel},),
                 chn)
end

function iio_channel_get_id(chn::Ptr{iio_channel})
    return unsafe_string(ccall((:iio_channel_get_id, libiio),
                               Cstring,
                               (Ptr{iio_channel},),
                               chn))
end

function iio_channel_get_name(chn::Ptr{iio_channel})
    name = ccall((:iio_channel_get_name, libiio),
                 Cstring,
                 (Ptr{iio_channel},),
                 chn)
    return name == C_NULL ? "" : unsafe_string(name)
end

function iio_channel_is_output(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_output, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

function iio_channel_is_scan_element(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_scan_element, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

function iio_channel_get_attrs_count(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_channel},),
                 chn)
end

function iio_channel_get_attr(chn::Ptr{iio_channel}, index::Cuint)
    attr = ccall((:iio_channel_get_attr, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cuint),
                 chn, index)

    return attr == C_NULL ? "" : unsafe_string(attr)
end

function iio_channel_find_attr(chn::Ptr{iio_channel}, name::String)
    attr = ccall((:iio_channel_find_attr, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cstring),
                 chn, name)

    return attr == C_NULL ? "" : unsafe_string(attr)
end

function iio_channel_attr_get_filename(chn::Ptr{iio_channel}, attr::String)
    name = ccall((:iio_channel_attr_get_filename, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cstring),
                 chn, attr)

    return name == C_NULL ? "" : unsafe_string(name)
end

function iio_channel_attr_read(chn::Ptr{iio_channel}, attr::String)
    attr == "" && (attr = C_NULL)
    dst = Vector{Cchar}(undef, BUF_SIZE)
    ret = ccall((:iio_channel_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_channel}, Cstring, Cstring, Csize_t),
                chn, attr, pointer(dst), BUF_SIZE)

    attr == C_NULL ? (attrs = iio_parse_attr(dst, ret)) :
    (attrs = unsafe_string(pointer(dst)))
    return ret, attrs
end

function iio_channel_attr_read_all(chn::Ptr{iio_channel}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_channel_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_channel}, Ptr{Cvoid}, Ptr{Cvoid}),
                 chn, cb, data)
end

function iio_channel_attr_read_bool(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_channel_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Cuchar}),
                chn, attr, value)
    return ret, convert(Bool, value[])
end

function iio_channel_attr_read_longlong(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_channel_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Clonglong}),
                chn, attr, value)
    return ret, value[]
end

function iio_channel_attr_read_double(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_channel_attr_read_double, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Cdouble}),
                chn, attr, value)
    return ret, value[]
end

function iio_channel_attr_write(chn::Ptr{iio_channel}, attr::String, src::String)
    return ccall((:iio_channel_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_channel}, Cstring, Cstring),
                 chn, attr, src)
end

function iio_channel_attr_write_raw(chn::Ptr{iio_channel}, attr::String, src::Ptr{Cvoid},
                                    len::Csize_t)
    return ccall((:iio_channel_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_channel}, Cstring, Ptr{Cvoid}, Csize_t),
                 chn, attr, src, len)
end

function iio_channel_attr_write_all(chn::Ptr{iio_channel}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_channel_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_channel}, Ptr{Cvoid}, Ptr{Cvoid}),
                 chn, cb, data)
end

function iio_channel_attr_write_bool(chn::Ptr{iio_channel}, attr::String, val::Bool)
    return ccall((:iio_channel_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Cuchar),
                 chn, attr, val)
end

function iio_channel_attr_write_longlong(chn::Ptr{iio_channel}, attr::String,
                                         val::Clonglong)
    return ccall((:iio_channel_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Clonglong),
                 chn, attr, val)
end

function iio_channel_attr_write_double(chn::Ptr{iio_channel}, attr::String, val::Cdouble)
    return ccall((:iio_channel_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Cdouble),
                 chn, attr, val)
end

function iio_channel_enable(chn::Ptr{iio_channel})
    ccall((:iio_channel_enable, libiio),
          Cvoid,
          (Ptr{iio_channel},),
          chn)
end

function iio_channel_disable(chn::Ptr{iio_channel})
    ccall((:iio_channel_disable, libiio),
          Cvoid,
          (Ptr{iio_channel},),
          chn)
end

function iio_channel_is_enabled(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_enabled, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

function iio_channel_read_raw(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                              dst::Vector{Cuchar})
    return ccall((:iio_channel_read_raw, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

function iio_channel_read(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                          dst::Vector{Cuchar})
    return ccall((:iio_channel_read, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

function iio_channel_write_raw(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                               dst::Vector{Cuchar})
    return ccall((:iio_channel_write_raw, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

function iio_channel_write(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                           dst::Vector{Cuchar})
    return ccall((:iio_channel_write, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

function iio_channel_set_data(chn::Ptr{iio_channel}, data::Ptr{Cvoid})
    ccall((:iio_channel_set_data, libiio),
          Cvoid,
          (Ptr{iio_channel}, Ptr{Cvoid}),
          chn, data)
end

function iio_channel_get_data(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_data, libiio),
                 Ptr{Cvoid},
                 (Ptr{iio_channel},),
                 chn)
end

function iio_channel_get_type(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_type, libiio),
                 iio_chan_type,
                 (Ptr{iio_channel},),
                 chn)
end

function iio_channel_get_modifier(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_modifier, libiio),
                 iio_modifier,
                 (Ptr{iio_channel},),
                 chn)
end
