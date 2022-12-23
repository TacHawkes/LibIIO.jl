"""
    iio_device_get_sample_size(dev)

Get the current sample size.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- On success, the sample size in bytes
- On error, a negative errno code is returned

!!! note
    The sample size is not constant and will change when channels get enabled or disabled.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga52b3e955c10d6f962b2c2e749c7c02fb)
"""
function iio_device_get_sample_size(dev::Ptr{iio_device})
    return ccall((:iio_device_get_sample_size, libiio),
                 Cssize_t,
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_channel_get_index(chn)

Get the index of the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- On success, a the index of the specified channel
- On error, an negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gaf9cc94902b5081bdacc4aed05e7d2412)
"""
function iio_channel_get_index(chn::Ptr{iio_channel})
    return convert(Int,
                   ccall((:iio_channel_get_index, libiio),
                         Clong,
                         (Ptr{iio_channel},),
                         chn))
end

"""
    iio_channel_get_data_format(chn)

Get a pointer to a channel's data format structure.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- A pointer to the channel's [`iio_data_format`](@ref) structure

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gadbb2dabfdd85c3f2c6b168f0512c7748)
"""
function iio_channel_get_data_format(chn::Ptr{iio_channel})
    df = ccall((:iio_channel_get_data_format, libiio),
               Ptr{iio_data_format},
               (Ptr{iio_channel},),
               chn)
    return unsafe_load(df)
end

"""
    iio_channel_convert(chn, dst, src)

Convert the sample from hardware format to host format.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `dst::Ptr{Cvoid}` : A pointer to the destination buffer where the converted sample should be written
- `src::Ptr{Cvoid}` : A pointer to the source buffer containing the sample

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gaf910dce06335badc1ba307526c4112a6)
"""
function iio_channel_convert(chn::Ptr{iio_channel}, dst::Ptr{Cvoid}, src::Ptr{Cvoid})
    ccall((:iio_channel_convert, libiio),
          Cvoid,
          (Ptr{iio_channel_convert}, Ptr{Cvoid}, Ptr{Cvoid}),
          chn, dst, src)
end

"""
    iio_channel_convert_inverse(chn, dst, src)

Convert the sample from host format to hardware format.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `dst::Ptr{Cvoid}` : A pointer to the destination buffer where the converted sample should be written
- `src::Ptr{Cvoid}` : A pointer to the source buffer containing the sample

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gaf0a9a659af18b62ffa0520301402eabb)
"""
function iio_channel_convert_inverse(chn::Ptr{iio_channel}, dst::Ptr{Cvoid},
                                     src::Ptr{Cvoid})
    ccall((:iio_channel_convert_inverse, libiio),
          Cvoid,
          (Ptr{iio_channel_convert}, Ptr{Cvoid}, Ptr{Cvoid}),
          chn, dst, src)
end

"""
    iio_device_get_debug_attrs_count(dev)

Enumerate the debug attributes of the given deivce.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- The number of debug attributes found

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gabacd0e63720d19e7335088c2fd19bbdc)
"""
function iio_device_get_debug_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_debug_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_debug_attr(dev, index)

Get the debug attribute present at the given index.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`] structure
- `index::Cuint` : The index corresponding to the debug attribute

# Returns
- On succes, a string containing the attribute value
- If the index is invalid, an empty string is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gafe451e9a078ed5588b43a4a34cf3b2bc)
"""
function iio_device_get_debug_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_debug_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_find_debug_attr(dev, name)

Try to find a debug attribute by its name.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`] structure

# Returns
- On success, a string with the attribute name
- If the name does not correspond to any known debug attribute of the given device, an empty string is returned

!!! note
    This function is useful to detect the presence of a debug attribute.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga2923f184fc57071db9fda14e16c40a9c)
"""
function iio_device_find_debug_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_debug_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_debug_attr_read(dev, attr)

Read the content of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, a Vector of Tuples of attribute index and value if
    `attr` is an empty string, otherwise a string with the attribute value.
- On error, a negative errno code is returned

!!! note
    By an empty string as the "attr" argument to [`iio_device_debug_attr_read`](@ref), it is now
    possible to read all of the buffer attributes of a device.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga8d786ee19093f86da4feb92fb91dd5d7)
"""
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

"""
    iio_device_debug_attr_read_all(dev, cb, data)

Read the content of all debug attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the debug attributes are read in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga1fb487123cf36ea55b650165d49a91ff)
"""
function iio_device_debug_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                        data::Ptr{Cvoid})
    return ccall((:iio_device_debug_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_debug_attr_write(dev, attr, src)

Set the value of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::String` A string to set the attribute to

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

!!! note
    By passing `C_NULL` as the "attr" argument to [`iio_device_debug_attr_write`](@ref),
    it is now possible to write all of the debug attributes of a device.

    The buffer must contain one block of data per attribute of the device,
    by the order they appear in the iio_device structure.

    The first four bytes of one block correspond to a 32-bit signed value
    in network order. If negative, the attribute is not written;
    if positive, it corresponds to the length of the data to write.
    In that case, the rest of the block must contain the data.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gaea7f639edb7efd15b718be4c7faaeae5)
"""
function iio_device_debug_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_debug_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

"""
    iio_device_debug_attr_write_raw(dev, attr, src, len)

Set the value of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::Ptr{Cvoid}` : A pointer to the data to be written
- `len::Csize_t` : The number of bytes that should be written

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga1eac5d59a58b6c8e2db892adce7a05a3)
"""
function iio_device_debug_attr_write_raw(dev::Ptr{iio_device}, attr::String,
                                         src::Ptr{Cvoid},
                                         len::Csize_t)
    return ccall((:iio_device_debug_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

"""
    iio_device_debug_attr_write_all(dev, cb, data)

Set the values of all debug attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the debug attributes are written in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga57e3af5219859303c2a8629e9b80f9ca)
"""
function iio_device_debug_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                         data::Ptr{Cvoid})
    return ccall((:iio_device_debug_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_debug_attr_read_bool(dev, attr)

Read the content of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the bool value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gadffd69effb8ff8ddb504ea9492a29529)
"""
function iio_device_debug_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_debug_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

"""
    iio_device_debug_attr_read_longlong(dev, attr)

Read the content of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Clonglong value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#gaff27d1a48f8469531c25471918d0b6de)
"""
function iio_device_debug_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_debug_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_debug_attr_read_double(dev, attr)

Read the content of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Cdouble value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga1356356c2eebcb56df2d72e93042d896)
"""
function iio_device_debug_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_debug_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_debug_attr_write_bool(dev, attr, val)

Set the value of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Bool` : A bool value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga40579d97ca0b68f2244bed67ece80ce6)
"""
function iio_device_debug_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_debug_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

"""
    iio_device_debug_attr_write_longlong(dev, attr, val)

Set the value of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Clonglong` : A Clonglong value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga22df5b7b0606a9e453fac421d15e6fb2)
"""
function iio_device_debug_attr_write_longlong(dev::Ptr{iio_device}, attr::String,
                                              val::Clonglong)
    return ccall((:iio_device_debug_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

"""
    iio_device_debug_attr_write_double(dev, attr, val)

Set the value of the given debug attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Cdouble` : A Cdouble value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga2a4e26d2d33db7fe9fc76d3034cb264f)
"""
function iio_device_debug_attr_write_double(dev::Ptr{iio_device}, attr::String,
                                            val::Cdouble)
    return ccall((:iio_device_debug_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

"""
    iio_device_identify_filename(dev, filename, chn, attr)

Identify the channel or debug attribute corresponding to a filename.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `filename::String` : A string corresponding to the filename
- `chn::Ptr{Ptr{iio_channel}}` : A pointer to a pointer of an [`iio_channel`](@ref).
                                 The pointed pointer will be set to the address of the
                                 [`iio_channel`](@ref) structure if the filename correspond
                                 to the attribute of a channel, or `C_NULL` otherwise.
- `attr::String` : A string field. The string will be set to the name of the attribute
                   corresponding to the filename.

# Returns
- On success, 0 is returned, and chn and attr are modified
- On error, a negative errno code is returned. chn and attr are not modified.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga87ef46fa578c7be7b3e2a6f9f16fdf7e)
"""
function iio_device_identify_filename(dev::Ptr{iio_device}, filename::String,
                                      chn::Ptr{Ptr{iio_channel}}, attr::String)
    return ccall((:iio_device_identify_filename, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Ptr{Ptr{iio_channel}}, Cstring),
                 dev, filename, chn, attr)
end

"""
    iio_device_reg_write(dev, address, value)

Set the value of a hardware register.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `address::Cuint` : The address of the register
- `value::Cuint` : The value to set the register to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga170d5a84de1d5fdb987113aa90e2a19b)
"""
function iio_device_reg_write(dev::Ptr{iio_device}, address::Cuint, value::Cuint)
    return ccall((:iio_device_reg_write, libiio),
                 Cint,
                 (Ptr{iio_device}, Cuint, Cuint),
                 dev, address, value)
end

"""
    iio_device_reg_read(dev, address)

Get the value of a hardware register.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `address::Cuint` : The address of the register

# Returns
- On success, 0 and the register value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Debug.html#ga70829552f676ef9fc74e755933da05d8)
"""
function iio_device_reg_read(dev::Ptr{iio_device}, address::Cuint)
    value = Ref{Cuint}()
    ret = ccall((:iio_device_reg_read, libiio),
                Cint,
                (Ptr{iio_device}, Cuint, Ptr{Cuint}),
                dev, address, value)
    return ret, value[]
end
