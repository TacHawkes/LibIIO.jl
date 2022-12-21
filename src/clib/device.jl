"""
    iio_device_get_context(dev)

Retrieve a pointer to the [`iio_context`](@ref) structure.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- A pointer to an [`iio_context`](@ref)

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gacc7d7b43ca5a1e228ef4c3a4952195fd)
"""
function iio_device_get_context(dev::Ptr{iio_device})
    return ccall((:iio_device_get_context, libiio),
                 Ptr{iio_context},
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_id(dev)

Retrieve the device ID (e.g. **iio:device0**)

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- A string containing the id

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga9e6610c3dd7cc45bebcc7ed7a1b064c6)
"""
function iio_device_get_id(dev::Ptr{iio_device})
    return unsafe_string(ccall((:iio_device_get_id, libiio),
                               Cstring,
                               (Ptr{iio_device},),
                               dev))
end

"""
    iio_device_get_name(dev)

Retrieve the device name (e.g. `xadc`)

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- A string containing the name

!!! note
    If the device has no name, an empty string is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga711666b3b3b6314fbe7e592b4632ab85)
"""
function iio_device_get_name(dev::Ptr{iio_device})
    name = ccall((:iio_device_get_name, libiio),
                 Cstring,
                 (Ptr{iio_device},),
                 dev)
    return name != C_NULL ? unsafe_string(name) : ""
end

"""
    iio_device_get_label(dev)

Retrieve the device label (e.g. `lo_pll0_rx_adf4351`)

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- A string containing the label

!!! note
    If the device has no label, an empty string is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaa7dfffe6431d1f36abf523470e866641)
"""
function iio_device_get_label(dev::Ptr{iio_device})
    label = ccall((:iio_device_get_label, libiio),
                  Cstring,
                  (Ptr{iio_device},),
                  dev)
    label != C_NULL ? unsafe_string(label) : ""
end

"""
    iio_device_get_channels_count(dev)

Enumerate the channels of the given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- The number of channels found

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gae10ff440f64dac52b4229eb3f2ebea76)
"""
function iio_device_get_channels_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_channels_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_attrs_count(dev)

Enumerate the device-specific attributes of the given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- The number of device-specific attributes found

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga36c2d0f703a803f44a578bc83fdab6a0)
"""
function iio_device_get_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_buffer_attrs_count(dev)

Enumerate the buffer-specific attributes of the given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- The number of buffer-specific attributes found

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga6d4bd3c4f9791c706d9baa4454e0f1d3)
"""
function iio_device_get_buffer_attrs_count(dev::Ptr{iio_device})
    return ccall((:iio_device_get_buffer_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_channel(dev, index)

Get the channel present at the given index.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `index::Cuint` : The index corresponding to the channel

# Returns
- On success, a pointer to an [`iio_channel`](@ref)
- If the index is invalid, an error is raised

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga67289d735b7d8e1ed12ae0ea642bd1ac)
"""
function iio_device_get_channel(dev::Ptr{iio_device}, index::Cuint)
    return @check_null ccall((:iio_device_get_channel, libiio),
                             Ptr{iio_channel},
                             (Ptr{iio_device}, Cuint),
                             dev, index)
end

"""
    iio_device_get_attr(dev, index)

Get the device-specific attribute present at the given index.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `index::Cuint` : The index corresponding to the attribute

# Returns
- On success, a string containing the attribute name
- If the index is invalid, an empty string will be returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga70b03d4cb3cc3c4fb1b6451764c8ccec)
"""
function iio_device_get_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_get_buffer_attr(dev, index)

Get the buffer-specific attribute present at the given index.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `index::Cuint` : The index corresponding to the attribute

# Returns
- On success, a string containing the attribute name
- If the index is invalid, an empty string will be returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga7225b9df06559012d549d627fb451c2a)
"""
function iio_device_get_buffer_attr(dev::Ptr{iio_device}, index::Cuint)
    attr = ccall((:iio_device_get_buffer_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cuint),
                 dev, index)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_find_channel(dev, name, output)

Try to find a channel structure by its name or ID.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `name::String` : A string corresponding to the name or ID of the channel to search for
- `output::Bool` : True if the searched channel is output, false otherwise

# Returns
- On success, a pointer to an [`iio_channel`](@ref) structure
- If the name or ID does not correspond to any known channel of the given device, an error is raised

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaffc6086189ba801ab5e95341d68f882b)
"""
function iio_device_find_channel(dev::Ptr{iio_device}, name::String, output::Bool)
    return @check_null ccall((:iio_device_find_channel, libiio),
                             Ptr{iio_channel},
                             (Ptr{iio_device}, Cstring, Cuchar),
                             dev, name, output)
end

"""
    iio_device_find_attr(dev, name)

Try to find a device-specific attribute by its name.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `name::String` : A string corresponding to the name of the attribute

# Returns
- On succes, a string containing the attribute name
- If the name does not correspond to any know aatribute of the device, an empty string is returned

!!! note
    This function is useful to detect the presence of an attribute.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gafcbece1ac6260b06bcdf02d9eb55e5fd)
"""
function iio_device_find_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_find_buffer_attr(dev, name)

Try to find a buffer-specific attribute by its name.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `name::String` : A string corresponding to the name of the attribute

# Returns
- On succes, a string containing the attribute name
- If the name does not correspond to any know aatribute of the device, an empty string is returned

!!! note
    This function is useful to detect the presence of an attribute.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga58baa15da06b2d497fb0334f35264240)
"""
function iio_device_find_buffer_attr(dev::Ptr{iio_device}, name::String)
    attr = ccall((:iio_device_find_buffer_attr, libiio),
                 Cstring,
                 (Ptr{iio_device}, Cstring),
                 dev, name)

    return attr != C_NULL ? unsafe_string(attr) : ""
end

"""
    iio_device_attr_read(dev, attr)

Read the content of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, a Vector of Tuples of attribute index and value if
  `attr` is an empty string, otherwise a string with the attribute value.
- On error, a negative errno code is returned

!!! note
    By an empty string as the "attr" argument to [`iio_device_attr_read`](@ref), it is now
    possible to read all of the attributes of a device.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaf0233eb0ef4a64ad70ebaef6328b0494)
"""
function iio_device_attr_read(dev::Ptr{iio_device}, attr::String)
    attr == "" && (attr = C_NULL)
    dst = Vector{Cuchar}(undef, BUF_SIZE)
    ret = ccall((:iio_device_attr_read, libiio),
                Cssize_t,
                (Ptr{iio_device}, Cstring, Cstring, Csize_t),
                dev, attr, pointer(dst), BUF_SIZE)

    attr == C_NULL ? attrs = iio_parse_attr(dst, ret) : attrs = unsafe_string(pointer(dst))
    return ret, attrs
end

"""
    iio_device_attr_read_all(dev, cb, data)

Read the content of all device-specific attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the device-specific attributes are read in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga5b1fef1333c4835942384b661f148b36)
"""
function iio_device_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_device_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_attr_read_bool(dev, attr)

Read the content of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the bool value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga96364b7c7097bb8e4656924ea896a502)
"""
function iio_device_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

"""
    iio_device_attr_read_longlong(dev, attr)

Read the content of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Clonglong value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga0f7b5d21a4e40efac68e1ece44d7ba74)
"""
function iio_device_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_attr_read_double(dev, attr)

Read the content of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Cdouble value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gab1b150a5bfa7b1ab7fd76c538e15e4da)
"""
function iio_device_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_attr_write(dev, attr, src)

Set the value of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::String` A string to set the attribute to

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

!!! note
    By passing `C_NULL` as the "attr" argument to [`iio_device_attr_write`](@ref),
    it is now possible to write all of the attributes of a device.

    The buffer must contain one block of data per attribute of the device,
    by the order they appear in the iio_device structure.

    The first four bytes of one block correspond to a 32-bit signed value
    in network order. If negative, the attribute is not written;
    if positive, it corresponds to the length of the data to write.
    In that case, the rest of the block must contain the data.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaaa2d1867c15ef8f8424164d0ccea4dd8)
"""
function iio_device_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

"""
    iio_device_attr_write_raw(dev, attr, src, len)

Set the value of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::Ptr{Cvoid}` : A pointer to the data to be written
- `len::Csize_t` : The number of bytes that should be written

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga30829a67dcdffc902c4ba6801233e79a)
"""
function iio_device_attr_write_raw(dev::Ptr{iio_device}, attr::String, src::Ptr{Cvoid},
                                   len::Csize_t)
    return ccall((:iio_device_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

"""
    iio_device_attr_write_all(dev, cb, data)

Set the values of all device-specifc attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the device-specific attributes are written in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gadfbbfafabc32d6954d3f3dfcda957735)
"""
function iio_device_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid}, data::Ptr{Cvoid})
    return ccall((:iio_device_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_attr_write_bool(dev, attr, val)

Set the value of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Bool` : A bool value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga9f53f9d1c3dc9f87191943fcbd1a7324)
"""
function iio_device_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

"""
    iio_device_attr_write_longlong(dev, attr, val)

Set the value of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Clonglong` : A Clonglong value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga3fcba684f6b07d3f6295759bb788c4d2)
"""
function iio_device_attr_write_longlong(dev::Ptr{iio_device}, attr::String, val::Clonglong)
    return ccall((:iio_device_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

"""
    iio_device_attr_write_double(dev, attr, val)

Set the value of the given device-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Cdouble` : A Cdouble value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gacdaf529f12b46ba2a5290bbc590c8b9e)
"""
function iio_device_attr_write_double(dev::Ptr{iio_device}, attr::String, val::Cdouble)
    return ccall((:iio_device_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

"""
    iio_device_buffer_attr_read(dev, attr)

Read the content of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, a Vector of Tuples of attribute index and value if
  `attr` is an empty string, otherwise a string with the attribute value.
- On error, a negative errno code is returned

!!! note
    By an empty string as the "attr" argument to [`iio_device_buffer_attr_read`](@ref), it is now
    possible to read all of the buffer attributes of a device.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaa77d52bb9dea248cc3de682778a08a6f)
"""
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

"""
    iio_device_buffer_attr_read_all(dev, cb::Ptr{Cvoid}, data)

Read the content of all buffer-specific attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the buffer-specific attributes are read in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gaae5bf33ad1bd1b14155eab4a018c576c)
"""
function iio_device_buffer_attr_read_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                         data::Ptr{Cvoid})
    return ccall((:iio_device_buffer_attr_read_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_buffer_attr_read_bool(dev, attr)

Read the content of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the bool value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga92ee863b94e6f841efec3919f57f5193)
"""
function iio_device_buffer_attr_read_bool(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cuchar}(0)
    ret = ccall((:iio_device_buffer_attr_read_bool, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cuchar}),
                dev, attr, value)
    return ret, convert(Bool, value[])
end

"""
    iio_device_buffer_attr_read_longlong(dev, attr)

Read the content of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Clonglong value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gae5b9be890edb372d3e30a14ce1c79874)
"""
function iio_device_buffer_attr_read_longlong(dev::Ptr{iio_device}, attr::String)
    value = Ref{Clonglong}(0)
    ret = ccall((:iio_device_buffer_attr_read_longlong, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Clonglong}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_buffer_attr_read_double(dev, attr)

Read the content of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute

# Returns
- On success, 0 and the Cdouble value is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga44952198b73ff6b0c0c0b53d3cd6d1bd)
"""
function iio_device_buffer_attr_read_double(dev::Ptr{iio_device}, attr::String)
    value = Ref{Cdouble}(0)
    ret = ccall((:iio_device_buffer_attr_read_double, libiio),
                Cint,
                (Ptr{iio_device}, Cstring, Ptr{Cdouble}),
                dev, attr, value)
    return ret, value[]
end

"""
    iio_device_buffer_attr_write(dev, attr, src)

Set the value of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::String` A string to set the attribute to

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

!!! note
    By passing `C_NULL` as the "attr" argument to [`iio_device_buffer_attr_write`](@ref),
    it is now possible to write all of the attributes of a device.

    The buffer must contain one block of data per attribute of the device,
    by the order they appear in the iio_device structure.

    The first four bytes of one block correspond to a 32-bit signed value
    in network order. If negative, the attribute is not written;
    if positive, it corresponds to the length of the data to write.
    In that case, the rest of the block must contain the data.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga3d77bb90c22eb1d0a13805bf69def068)
"""
function iio_device_buffer_attr_write(dev::Ptr{iio_device}, attr::String, src::String)
    return ccall((:iio_device_buffer_attr_write, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Cstring),
                 dev, attr, src)
end

"""
    iio_device_buffer_attr_write_raw(dev, attr, src, len)

Set the value of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `src::Ptr{Cvoid}` : A pointer to the data to be written
- `len::Csize_t` : The number of bytes that should be written

# Returns
- On success, the number of bytes written
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga982e2bcb890aab88eabf833a00ba841a)
"""
function iio_device_buffer_attr_write_raw(dev::Ptr{iio_device}, attr::String,
                                          src::Ptr{Cvoid},
                                          len::Csize_t)
    return ccall((:iio_device_buffer_attr_write_raw, libiio),
                 Cssize_t,
                 (Ptr{iio_device}, Cstring, Ptr{Cvoid}, Csize_t),
                 dev, attr, src, len)
end

"""
    iio_device_buffer_attr_write_all(dev, cb, data)

Set the values of all buffer-specifc attributes.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `cb::Ptr{Cvoid}` : A pointer to a callback function
- `data::Ptr{Cvoid}` : A pointer that will be passed to the callback function

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

!!! note
    This function is especially useful when used with the network backend,
    as all the buffer-specific attributes are written in one single command.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga3d77bb90c22eb1d0a13805bf69def068)
"""
function iio_device_buffer_attr_write_all(dev::Ptr{iio_device}, cb::Ptr{Cvoid},
                                          data::Ptr{Cvoid})
    return ccall((:iio_device_buffer_attr_write_all, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{Cvoid}, Ptr{Cvoid}),
                 dev, cb, data)
end

"""
    iio_device_buffer_attr_write_bool(dev, attr, val)

Set the value of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Bool` : A bool value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga3fad39798014287c24c36bac4a67648e)
"""
function iio_device_buffer_attr_write_bool(dev::Ptr{iio_device}, attr::String, val::Bool)
    return ccall((:iio_device_buffer_attr_write_bool, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cuchar),
                 dev, attr, val)
end

"""
    iio_device_buffer_attr_write_longlong(dev, attr, val)

Set the value of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Clonglong` : A Clonglong value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gac05869aa707121328dd72cdad10cedf2)
"""
function iio_device_buffer_attr_write_longlong(dev::Ptr{iio_device}, attr::String,
                                               val::Clonglong)
    return ccall((:iio_device_buffer_attr_write_longlong, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Clonglong),
                 dev, attr, val)
end

"""
    iio_device_buffer_attr_write_double(dev, attr, val)

Set the value of the given buffer-specific attribute.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `attr::String` : A string corresponding to the name of the attribute
- `val::Cdouble` : A Cdouble value to set the attribute to

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga10d47af8de4ad1f9dc4b63ce0aa0ff7d)
"""
function iio_device_buffer_attr_write_double(dev::Ptr{iio_device}, attr::String,
                                             val::Cdouble)
    return ccall((:iio_device_buffer_attr_write_double, libiio),
                 Cint,
                 (Ptr{iio_device}, Cstring, Cdouble),
                 dev, attr, val)
end

"""
    iio_device_set_data(dev, data)

Associate a pointer to an [`iio_device`](@ref) structure.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `data::Ptr{Cvoid}` : The pointer to be associated

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gab566248f50503d8975cf258a1f218275)
"""
function iio_device_set_data(dev::Ptr{iio_device}, data::Ptr{Cvoid})
    ccall((:iio_device_set_data, libiio),
          Cvoid,
          (Ptr{iio_device}, Ptr{Cvoid}),
          dev, data)
end

"""
    iio_device_get_data(dev)

Retrieve a previously associated pointer of an [`iio_device`](@ref) structure.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- The pointer previously associated if present, or C_NULL

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga87cff8d90e1a68e73410e4a527cc5334)
"""
function iio_device_get_data(dev::Ptr{iio_device})
    return ccall((:iio_device_get_data, libiio),
                 Ptr{Cvoid},
                 (Ptr{iio_device},),
                 dev)
end

"""
    iio_device_get_trigger(dev)

Retrieve the trigger of a given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `trigger::Ptr{iio_device}` : A pointer to an [`iio_device`][@ref] structure. The pointer
                               will be set to the address of the [`iio_device`](@ref)
                               structure corresponding to the associated trigger device.

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#gae3ce1d7385ca02a9f6c36768fa41c610)
"""
function iio_device_get_trigger(dev::Ptr{iio_device})
    trigger = Ptr{iio_device}()
    ret = ccall((:iio_device_get_trigger, libiio),
                Cint,
                (Ptr{iio_device}, Ref{Ptr{iio_device}}),
                dev, Ref(trigger))
    return ret, trigger
end

"""
    iio_device_set_trigger(dev, trigger)

Associate a trigger to a given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `trigger::Ptr{iio_device` : A pointer to an [`iio_device`](@ref) structure corresponding
                              to the trigger that should be associated.

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga3b8d1e621357f0755925d98555f53d9a)
"""
function iio_device_set_trigger(dev::Ptr{iio_device}, trigger::Ptr{iio_device})
    return ccall((:iio_device_set_trigger, libiio),
                 Cint,
                 (Ptr{iio_device}, Ptr{iio_device}),
                 dev, trigger)
end

"""
    iio_device_is_trigger(dev)

Returns true of the given device is a trigger.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure

# Returns
- True if the deivce is a trigger, false otherwise

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga7e3e5dee1ac8c082de038829c88edda8)
"""
function iio_device_is_trigger(dev::Ptr{iio_device})
    return convert(Bool,
                   ccall((:iio_device_is_trigger, libiio),
                         Cuchar,
                         (Ptr{iio_device},),
                         dev))
end

"""
    iio_device_set_kernel_buffers_count(dev, nb_buffers)

Configure the number of kernel buffers for a device.

This function allows to change the number of buffers on kernel side.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `nb_buffers::Cuint` : The number of buffers

# Returns
- On success, 0 is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Device.html#ga8ad2357c4caf7afc778060a08e6e2209)
"""
function iio_device_set_kernel_buffers_count(dev::Ptr{iio_device}, nb_buffers::Cuint)
    return ccall((:iio_device_set_kernel_buffers_count, libiio),
                 Cint,
                 (Ptr{iio_device}, Cuint),
                 dev, nb_buffers)
end
