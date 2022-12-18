"""

https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga21076125f817a680e0c01d4a490f0416
"""
function iio_create_default_context()
    return @check_null ccall((:iio_create_default_context, libiio),
                             Ptr{iio_context},
                             ())
end

function iio_create_local_context()
    return @check_null ccall((:iio_create_local_context, libiio),
                             Ptr{iio_context},
                             ())
end

function iio_create_xml_context(xml_file::String)
    return @check_null ccall((:iio_create_xml_context, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             xml_file)
end

function iio_create_xml_context_mem(xml::String, len::Csize_t)
    return @check_null ccall((:iio_create_xml_context_mem, libiio),
                             Ptr{iio_context},
                             (Cstring, Csize_t),
                             xml, len)
end

function iio_create_network_context(host::String)
    return @check_null ccall((:iio_create_network_context, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             host)
end

function iio_create_context_from_uri(uri::String)
    return @check_null ccall((:iio_create_context_from_uri, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             uri)
end

function iio_context_clone(ctx::Ptr{iio_context})
    return @check_null ccall((:iio_context_clone, libiio),
                             Ptr{iio_context},
                             (Ptr{iio_context},),
                             ctx)
end

function iio_context_destroy(ctx::Ptr{iio_context})
    return @check_null ccall((:iio_context_destroy, libiio),
                             Cvoid,
                             (Ptr{iio_context},),
                             ctx)
end

function iio_context_get_version(ctx::Ptr{iio_context})
    major, minor, git_tag = Ref{Cuint}(0), Ref{Cuint}(0), Vector{Cchar}(undef, 8)

    ret = ccall((:iio_context_get_version, libiio),
                Cint,
                (Ptr{iio_context}, Ref{Cuint}, Ref{Cuint}, Ptr{Cchar}),
                ctx, major, minor, pointer(git_tag))

    return ret, UInt(major[]), UInt(minor[]), unsafe_string(pointer(git_tag))
end

function iio_context_get_xml(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_xml, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

function iio_context_get_name(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_name, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

function iio_context_get_description(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_description, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

function iio_context_get_attrs_count(ctx::Ptr{iio_context})
    return ccall((:iio_context_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_context},),
                 ctx)
end

function iio_context_get_attr(ctx::Ptr{iio_context}, index::Cuint)
    name, value = Ref{Cstring}(), Ref{Cstring}()
    ret = ccall((:iio_context_get_attr, libiio),
                Cint,
                (Ptr{iio_context}, Cuint, Ptr{Cstring}, Ptr{Cstring}),
                ctx, index, name, value)

    return (ret == 0) ? (ret, unsafe_string(name[]), unsafe_string(value[])) : (ret, "", "")
end

function iio_context_get_attr_value(ctx::Ptr{iio_context}, name::String)
    value = ccall((:iio_context_get_attr_value, libiio),
                  Cstring,
                  (Ptr{iio_context}, Cstring),
                  ctx, name)

    return value != C_NULL ? unsafe_string(value) : ""
end

function iio_context_get_devices_count(ctx::Ptr{iio_context})
    return ccall((:iio_context_get_devices_count, libiio),
                 Cuint,
                 (Ptr{iio_context},),
                 ctx)
end

function iio_context_get_device(ctx::Ptr{iio_context}, index::Cuint)
    return @check_null ccall((:iio_context_get_device, libiio),
                             Ptr{iio_device},
                             (Ptr{iio_context}, Cuint),
                             ctx, index)
end

function iio_context_find_device(ctx::Ptr{iio_context}, name::String)
    return @check_null ccall((:iio_context_find_device, libiio),
                             Ptr{iio_device},
                             (Ptr{iio_context}, Cstring),
                             ctx, name)
end

function iio_context_set_timeout(ctx::Ptr{iio_context}, timeout_ms::Cuint)
    return ccall((:iio_context_set_timeout, libiio),
                 Cint,
                 (Ptr{iio_context}, Cuint),
                 ctx, timeout_ms)
end
