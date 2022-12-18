function iio_device_get_sample_size(dev::Ptr{iio_device})
    return ccall((:iio_device_get_sample_size, libiio),
                 Cssize_t,
                 (Ptr{iio_device},),
                 dev)
end

function iio_channel_get_index(chn::Ptr{iio_channel})
    return convert(Int,
                   ccall((:iio_channel_get_index, libiio),
                         Clong,
                         (Ptr{iio_channel},),
                         chn))
end

function iio_channel_get_data_format(chn::Ptr{iio_channel})
    df = ccall((:iio_channel_get_data_format, libiio),
                 Ptr{iio_data_format},
                 (Ptr{iio_channel},),
                 chn)
    return unsafe_load(df)
end

function iio_channel_convert(chn::Ptr{iio_channel}, dst::Ptr{Cvoid}, src::Ptr{Cvoid})
    ccall((:iio_channel_convert, libiio),
          Cvoid,
          (Ptr{iio_channel_convert}, Ptr{Cvoid}, Ptr{Cvoid}),
          chn, dst, src)
end

function iio_channel_convert_inverse(chn::Ptr{iio_channel}, dst::Ptr{Cvoid},
                                     src::Ptr{Cvoid})
    ccall((:iio_channel_convert_inverse, libiio),
          Cvoid,
          (Ptr{iio_channel_convert}, Ptr{Cvoid}, Ptr{Cvoid}),
          chn, dst, src)
end

function iio_device_get_debug_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_debug_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

function iio_device_get_debug_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_debug_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_find_debug_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_debug_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

function iio_device_debug_attr_read(dev::Ptr{iio_device}, attr::String)
    attr == "" && (attr = C_NULL)
    dst = Vector{Cchar}(undef, BUF_SIZE)
    ret = ccall((:iio_device_debug_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_device}, Cstring, Cstring, Csize_t),
                dev, attr, pointer(dst), BUF_SIZE)

    attr == C_NULL ? attrs = iio_parse_attr(dst, ret) : attrs = unsafe_string(pointer(dst))
    return ret, attrs
end

function iio_device_debug_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                        data::Ptr{Cvoid})
    return ccall((:iio_device_debug_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_debug_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_debug_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

function iio_device_debug_attr_write_raw(dev::Ptr{iio_device}, attr::String,
                                         src::Ptr{Cvoid},
                                         len::Csize_t)
    return ccall((:iio_device_debug_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

function iio_device_debug_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_device_debug_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

function iio_device_debug_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_debug_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

function iio_device_debug_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_debug_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_debug_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_debug_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

function iio_device_debug_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_debug_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

function iio_device_debug_attr_write_longlong(dev::Ptr{iio_device}, attr::String, val::Clonglong)
    return ccall((:iio_device_debug_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

function iio_device_debug_attr_write_double(dev::Ptr{iio_device}, attr::String, val::Cdouble)
    return ccall((:iio_device_debug_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

function iio_device_identify_filename(dev::Ptr{iio_device}, filename::String, chn::Ptr{Ptr{iio_channel}}, attr::String)
    return ccall((:iio_device_identify_filename, libiio),
            Cint,
            (Ptr{iio_device}, Cstring, Ptr{Ptr{iio_channel}}, Cstring),
            dev, filename, chn, attr
    )
end

function iio_device_reg_write(dev::Ptr{iio_device}, address::Cuint, value::Cuint)
    return ccall((:iio_device_reg_write, libiio),
            Cint,
            (Ptr{iio_device}, Cuint, Cuint),
            dev, address, value
    )
end

function iio_device_reg_read(dev::Ptr{iio_device}, address::Cuint)
    value = Ref{Cuint}()
    ret = ccall((:iio_device_reg_read, libiio),
            Cint,
            (Ptr{iio_device}, Cuint, Ptr{Cuint}),
            dev, address, value
    )
    return ret, value[]
end
