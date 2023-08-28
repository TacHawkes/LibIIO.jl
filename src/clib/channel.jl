"""
    iio_channel_get_device(chn)

Retrieve a pointer to the [`iio_device`](@ref) structure.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- A pointer to a [`iio_device`](@ref) structure

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gaf2800d7a6953c5dd3271df390c062439)
"""
function iio_channel_get_device(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_device, libiio),
                 Ptr{iio_device},
                 (Ptr{iio_channel},),
                 chn)
end

"""
    iio_channel_get_id(chn)

Retrieve the channel ID (e.g. `voltage0`)

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- A string with the channel ID

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gafda1782de4655905ad08a40492f3dc64)
"""
function iio_channel_get_id(chn::Ptr{iio_channel})
    return unsafe_string(ccall((:iio_channel_get_id, libiio),
                               Cstring,
                               (Ptr{iio_channel},),
                               chn))
end

"""
    iio_channel_get_name(chn)

Retrieve the channel name (e.g. `vccint`)

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- A string with the channel name

!!! note
    If the channel has no name, an empty string is returned.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga37346a6f3fcfb1eb40572aec6c3b39ac)
"""
function iio_channel_get_name(chn::Ptr{iio_channel})
    name = ccall((:iio_channel_get_name, libiio),
                 Cstring,
                 (Ptr{iio_channel},),
                 chn)
    return name == C_NULL ? "" : unsafe_string(name)
end

"""
    iio_channel_is_output(chn)

Return true if the given channel is an output channel

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- True if the channel is an output channel, false otherweise

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga3c24e9c93e2217c9506073d04b878461)
"""
function iio_channel_is_output(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_output, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

"""
    iio_channel_is_scan_element(chn)

Return true of the given channel is a scan element.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- True if the channel is a scan element, false otherweise

!!! note
    A channel that is a scan element is a channel that can generate samples
    (for an input channel) or receive samples (for an output channel) after being enabled.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga07892a3c0c31e7a3eecf76ec72a8669d)
"""
function iio_channel_is_scan_element(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_scan_element, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

"""
    iio_channel_get_attrs_count(chn)

Enumerate the channel-specific attributes of the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- The number of channel-specific attributes found

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga14869c3fda8b04f413a02f15dfa6ef7c)
"""
function iio_channel_get_attrs_count(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_channel},),
                 chn)
end

"""
    iio_channel_get_attr(chn, index)

Get the channel-specific attribute present at the given index.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `index::Cuint` : The index corresponding to the attribute

# Returns
- On success, a string containing the attribute name
- If the index is invalid, an empty string will be returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gafc3c52f360424c097a24d1925923d772)
"""
function iio_channel_get_attr(chn::Ptr{iio_channel}, index::Cuint)
    attr = ccall((:iio_channel_get_attr, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cuint),
                 chn, index)

    return attr == C_NULL ? "" : unsafe_string(attr)
end

"""
    iio_channel_find_attr(chn, name)

Try to find a channel-specific attribute by its name.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `name::String` : A string corresponding to the name of the attribute

# Returns
- On succes, a string containing the attribute name
- If the name does not correspond to any know atribute of the channel, an empty string is returned

!!! note
    This function is useful to detect the presence of an attribute.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga13b2db3252a2380a2b0b1bb15b8034a4)
"""
function iio_channel_find_attr(chn::Ptr{iio_channel}, name::String)
    attr = ccall((:iio_channel_find_attr, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cstring),
                 chn, name)

    return attr == C_NULL ? "" : unsafe_string(attr)
end

"""
    iio_channel_attr_get_filename(chn, attr)

Retrieve the filename of an attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` ; A string corresponding to the name of the attribute

# Returns
- On success, a string with the filename
- If the attribute is unknown, an empty string is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gab6462404bb6667e9e9241a18e09a1638)
"""
function iio_channel_attr_get_filename(chn::Ptr{iio_channel}, attr::String)
    name = ccall((:iio_channel_attr_get_filename, libiio),
                 Cstring,
                 (Ptr{iio_channel}, Cstring),
                 chn, attr)

    return name == C_NULL ? "" : unsafe_string(name)
end

"""
    iio_channel_attr_read(dev, attr)

Read the content of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, a string with the attribute value.
- On error, a negative errno code is returned

!!! note
    This function deviates from the C library [`iio_channel_attr_read`](@ref).
    Instead of passing an empty string, call the function without the attr argument.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga2c2ca5696d1341067051eb390d5014ae)
"""
function iio_channel_attr_read(chn::Ptr{iio_channel}, attr::String)
    dst = DST_BUFFER
    ret = ccall((:iio_channel_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_channel}, Cstring, Cstring, Csize_t),
                chn, attr, pointer(dst), BUF_SIZE)

    attrs = unsafe_string(pointer(dst))
    return ret, attrs
end

"""
    iio_channel_attr_read(dev)

Read the content of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- On success, a Vector of Tuples of attribute index and value.
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga2c2ca5696d1341067051eb390d5014ae)
"""
function iio_channel_attr_read(chn::Ptr{iio_channel})
    attr = C_NULL
    dst = DST_BUFFER
    ret = ccall((:iio_channel_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_channel}, Cstring, Cstring, Csize_t),
                chn, attr, pointer(dst), BUF_SIZE)

    attrs = iio_parse_attr(dst, ret)
    return ret, attrs
end

"""
    iio_channel_attr_read_all(dev, cb, data)

Read the content of all channel-specific attributes.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the channel-specific attributes are read in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gab9c28b0cd94c0607bcc7cac16219eb48)
"""
function iio_channel_attr_read_all(chn::Ptr{iio_channel}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_channel_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_channel}, Ptr{Cvoid}, Ptr{Cvoid}),
                 chn, cb, data)
end

"""
    iio_channel_attr_read_bool(dev, attr)

Read the content of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the bool value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga319f39c313bbd4d331e23df51e4d3ce6)
"""
function iio_channel_attr_read_bool(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_channel_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Cuchar}),
                chn, attr, value)
    return ret, convert(Bool, value[])
end

"""
    iio_channel_attr_read_longlong(dev, attr)

Read the content of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Clonglong value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga116c61892bf3d20ff07efd642c5dfbe1)
"""
function iio_channel_attr_read_longlong(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_channel_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Clonglong}),
                chn, attr, value)
    return ret, value[]
end

"""
    iio_channel_attr_read_double(dev, attr)

Read the content of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Cdouble value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga75ac9b81eb7e7e8a961afb67748e4102)
"""
function iio_channel_attr_read_double(chn::Ptr{iio_channel}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_channel_attr_read_double, libiio),
                Cint,
                (Ptr{iio_channel}, Cstring, Ptr{Cdouble}),
                chn, attr, value)
    return ret, value[]
end

"""
    iio_channel_attr_write(dev, attr, src)

Set the value of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::String` A string to set the attribute to

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

!!! note
    By passing `C_NULL` as the "attr" argument to [`iio_channel_attr_write`](@ref),
    it is now possible to write all of the attributes of a device.

    The buffer must contain one block of data per attribute of the device,
    by the order they appear in the iio_device structure.

    The first four bytes of one block correspond to a 32-bit signed value
    in network order. If negative, the attribute is not written;
    if positive, it corresponds to the length of the data to write.
    In that case, the rest of the block must contain the data.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga35c76ce5fcae4c551b7c78d648665a41)
"""
function iio_channel_attr_write(chn::Ptr{iio_channel}, attr::String, src::String)
    return ccall((:iio_channel_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_channel}, Cstring, Cstring),
                 chn, attr, src)
end

"""
    iio_channel_attr_write_raw(dev, attr, src, len)

Set the value of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::Ptr{Cvoid}` : A pointer to the data to be written
- `len::Csize_t` : The number of bytes that should be written

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gacd0d3dd36bdc64a9f967e21a891230eb)
"""
function iio_channel_attr_write_raw(chn::Ptr{iio_channel}, attr::String, src::Ptr{Cvoid},
                                    len::Csize_t)
    return ccall((:iio_channel_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_channel}, Cstring, Ptr{Cvoid}, Csize_t),
                 chn, attr, src, len)
end

"""
    iio_channel_attr_write_all(dev, cb, data)

Set the values of all channel-specifc attributes.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the chsnnel-specific attributes are written in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga6df693ee4f0c329d957f7c7ca3588f3f)
"""
function iio_channel_attr_write_all(chn::Ptr{iio_channel}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_channel_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_channel}, Ptr{Cvoid}, Ptr{Cvoid}),
                 chn, cb, data)
end

"""
    iio_channel_attr_write_bool(dev, attr, val)

Set the value of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Bool` : A bool value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga9a385b9b05d20f33f8e587feb2ebe81a)
"""
function iio_channel_attr_write_bool(chn::Ptr{iio_channel}, attr::String, val::Bool)
    return ccall((:iio_channel_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Cuchar),
                 chn, attr, val)
end

"""
    iio_channel_attr_write_longlong(dev, attr, val)

Set the value of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Clonglong` : A Clonglong value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gac55cb77a1baf797e54a8a4e31b2f4680)
"""
function iio_channel_attr_write_longlong(chn::Ptr{iio_channel}, attr::String,
                                         val::Clonglong)
    return ccall((:iio_channel_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Clonglong),
                 chn, attr, val)
end

"""
    iio_channel_attr_write_double(dev, attr, val)

Set the value of the given channel-specific attribute.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Cdouble` : A Cdouble value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gad9d6ec4a02948c6416cc99254bdbfa50)
"""
function iio_channel_attr_write_double(chn::Ptr{iio_channel}, attr::String, val::Cdouble)
    return ccall((:iio_channel_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_channel}, Cstring, Cdouble),
                 chn, attr, val)
end

"""
    iio_channel_enable(chn)

Enable the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

!!! note
    Before creating an [`iio_buffer`](@ref) structure with [`iio_device_create_buffer`](@ref),
    it is required to enable at least one channel of the device to read from.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga2b787983683d37966b5e1e5c6c121d6a)
"""
function iio_channel_enable(chn::Ptr{iio_channel})
    ccall((:iio_channel_enable, libiio),
          Cvoid,
          (Ptr{iio_channel},),
          chn)
end

"""
    iio_channel_disable(chn)

Disable the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gad7c7c91c61b8a97187dc73cbcdb60c06)
"""
function iio_channel_disable(chn::Ptr{iio_channel})
    ccall((:iio_channel_disable, libiio),
          Cvoid,
          (Ptr{iio_channel},),
          chn)
end

"""
    iio_channel_is_enabled(chn)

Returns true of the channel is enabled.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- True if the channel is enabled, false otherwise

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gaf10427dc35adaa0991cd34a9dd45a82f)
"""
function iio_channel_is_enabled(chn::Ptr{iio_channel})
    return convert(Bool,
                   ccall((:iio_channel_is_enabled, libiio),
                         Cuchar,
                         (Ptr{iio_channel},),
                         chn))
end

"""
    iio_channel_read_raw(chn, buffer, dst)

Demultiplex the samples of a given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `buffer::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `dst::Vector{Cuchar}` : A destination memory area where the demultiplexed data will be stored

# Returns
- The size of the demultiplexed data, in bytes

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gacd227a6861960ea2fb49d957f62887dd)
"""
function iio_channel_read_raw(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                              dst::Vector{Cuchar})
    return ccall((:iio_channel_read_raw, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

"""
    iio_channel_read(chn, buffer, dst)

Demultiplex and convert the samples of a given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `buffer::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `dst::Vector{Cuchar}` : A destination memory area where the converted data will be stored

# Returns
- The size of the converted data, in bytes

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga5c01edc37b0b57aef503abd5989a6a30)
"""
function iio_channel_read(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                          dst::Vector{Cuchar})
    return ccall((:iio_channel_read, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(dst), length(dst))
end

"""
    iio_channel_write_raw(chn, buffer, dst)

Multiplex the samples of a given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `buffer::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `src::Vector{Cuchar}` : A source memory area where the sequential data will be read from

# Returns
- The number of bytes actually multiplexed

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga350e81855764c159c6aefa12fb78e1c2)
"""
function iio_channel_write_raw(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                               src::Vector{Cuchar})
    return ccall((:iio_channel_write_raw, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(src), length(src))
end

"""
    iio_channel_write(chn, buffer, dst)

Convert and multiplex the samples of a given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `buffer::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `src::Vector{Cuchar}` : A source memory area where the sequential data will be read from

# Returns
- The number of bytes actually converted and multiplexed

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga350e81855764c159c6aefa12fb78e1c2)
"""
function iio_channel_write(chn::Ptr{iio_channel}, buffer::Ptr{iio_buffer},
                           src::Vector{Cuchar})
    return ccall((:iio_channel_write, libiio),
                 Csize_t,
                 (Ptr{iio_channel}, Ptr{iio_buffer}, Ptr{Cuchar}, Csize_t),
                 chn, buffer, pointer(src), length(src))
end

"""
    iio_channel_set_data(dev, data)

Associate a pointer to an [`iio_channel`](@ref) structure.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure
- `data::Ptr{Cvoid}` : The pointer to be associated

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga5150c9b73386d899460ebafbe614f338)
"""
function iio_channel_set_data(chn::Ptr{iio_channel}, data::Ptr{Cvoid})
    ccall((:iio_channel_set_data, libiio),
          Cvoid,
          (Ptr{iio_channel}, Ptr{Cvoid}),
          chn, data)
end

"""
    iio_channel_get_data(dev)

Retrieve a previously associated pointer of an [`iio_channel`](@ref) structure.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- The pointer previously associated if present, or C_NULL

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#gacbce92eaefb8d61c1e4f0dc042b211e6)
"""
function iio_channel_get_data(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_data, libiio),
                 Ptr{Cvoid},
                 (Ptr{iio_channel},),
                 chn)
end

"""
    iio_channel_get_type(chn)

Get the type of the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- The type of the channel

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga281660051fb40b5b4055227466a3be36)
"""
function iio_channel_get_type(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_type, libiio),
                 iio_chan_type,
                 (Ptr{iio_channel},),
                 chn)
end

"""
    iio_channel_get_modifier(chn)

Get the modifier type of the given channel.

# Parameters
- `chn::Ptr{iio_channel}` : A pointer to an [`iio_channel`](@ref) structure

# Returns
- The modifier type of the channel

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Channel.html#ga4c3179cee86d8992ee6c6bdbcaa44156)
"""
function iio_channel_get_modifier(chn::Ptr{iio_channel})
    return ccall((:iio_channel_get_modifier, libiio),
                 iio_modifier,
                 (Ptr{iio_channel},),
                 chn)
end
