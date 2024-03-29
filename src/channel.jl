"""
    ChannelAttr <: Attr

Represents an attribute of a IIO channel
"""
struct ChannelAttr <: Attr
    channel::Ptr{iio_channel}
    name::String
    filename::String
end

"""
    ChannelAttr(chn::Ptr{iio_channel}, name::String)

Initializes a new instance of a ChannelAttr.

# Parameters
- `chn::Ptr{iio_channel}` : A valid pointer to an [`iio_channel`](@ref)
- `name::String` : The channel attribute's name

# Returns
- A new instance of this type
"""
function ChannelAttr(chn::Ptr{iio_channel}, name::String)
    return ChannelAttr(chn,
                       name,
                       _c_get_filename(chn, name))
end

read(a::ChannelAttr) = _c_read_attr(a.channel, a.name)
write(a::ChannelAttr, value) = _c_write_attr(a.channel, a.name, value)

function show(io::IO, ::MIME"text/plain", chn::AbstractChannel, tree_depth = 0)
    _chn = iio_channel(chn)
    if chn.output
        type_name = "output"
    else
        type_name = "input"
    end

    _name = name(chn)
    _id = id(chn)
    print(io, "\t"^tree_depth, "$_id: $_name ($type_name")

    (type(chn) == IIO_CHAN_TYPE_UNKNOWN) &&
        print(io, ", WARN::iio_channel_get_type()=UNKNOWN")

    if chn.scan_element
        format = _channel_get_data_format(_chn)
        _sign = convert(Bool, format.is_signed) ? 's' : 'u'
        _repeat = ""
        convert(Bool, format.is_fully_defined) && (_sign += 'A' - 'a')
        _idx = iio_channel_get_index(_chn)
        _endianness = convert(Bool, format.is_be) ? 'b' : 'l'

        if format.repeat > 1
            _repeat = "X$(format.repeat)"
        end

        println(io,
                ", index: $_idx, format: $(_endianness)e:$(_sign)$(format.bits)/$(format.length)$_repeat>>$(format.shift))")
    else
        println(io, ")")
    end

    nb_attrs = iio_channel_get_attrs_count(_chn)
    if nb_attrs > 0
        println(io, "\t"^tree_depth, "$nb_attrs channel-specific attributes found:")

        k = 0
        for (_name, attr) in chn.attrs
            show(io, MIME("text/plain"), attr, tree_depth + 1, k)

            k += 1
        end
    end
end

iio_channel(chn::AbstractChannel) = chn.channel

"""
    read(chn::AbstractChannel, buf::AbstractBuffer, raw=false)

Extract the samples corresponding to this channel from the given buffer.

# Parameters
- `chn::Channel` : The channel instance
- `buf::AbstractBuffer` :  A buffer instance
- `raw::Bool`:  If set to true, the samples are not converted from their
                native format to their host format

# Returns
- A `Vector{Cuchar}` containing the samples for this channel
"""
function read(chn::AbstractChannel, buf::AbstractBuffer, raw = false)
    dst = Vector{Cuchar}(undef, length(buf))
    if raw
        len = _c_read_raw(iio_channel(chn), buf.buffer, dst)
    else
        len = _c_read(iio_channel(chn), buf.buffer, dst)
    end
    return dst
end

"""
    read(chn::AbstractChannel, buf::AbstractBuffer, data::Vector{T}, raw=false) where {T}

Write the specified vector of samples into the buffer the specified channel.

# Parameters
- `chn::Channel` : The channel instance
- `buf::AbstractBuffer` :  A buffer instance
- `data::Vector{T}` : A data vector containing the samples to copy
- `raw::Bool`:  If set to true, the samples are not converted from their
                host format to their native format

# Returns
- The number of bytes written
"""
function write(chn::AbstractChannel, buf::AbstractBuffer, data::Vector{T}, raw = false) where {T}
    _data = reinterpret(Cuchar, data)
    if raw
        return _c_write_raw(iio_channel(chn), buf.buffer, _data)
    end
    return _c_write(iio_channel(chn), buf.buffer, _data)
end


name(chn::AbstractChannel) = chn.name

"""
    id(chn)

An identifier of this channel.
Note that it is possible that two channels have the same ID,
if one is an input channel and the other is an output channel.
"""
id(chn::AbstractChannel) = chn.id

"""
    attrs(chn)

List of attributes for the given channel.
"""
attrs(chn::AbstractChannel) = chn.attrs

"""
    output(chn)

Contains true if the channel is an output channel, false otherwise.
"""
output(chn::AbstractChannel) = chn.output

"""
    scan_element(chn)

Contains true if the channel is a scan element, false otherwise.
"""
scan_element(chn::AbstractChannel) = chn.scan_element

"""
    enabled(chn)

Returns true if the channel is enabled, false otherwise.
"""
enabled(chn::AbstractChannel) = _c_is_enabled(iio_channel(chn))

"""
    enabled!(chn, state)

Sets the channel state to enabled if true, disabled otherwise.
"""
enabled!(chn::AbstractChannel, state) = state ? _c_enable(iio_channel(chn)) : _c_disable(iio_channel(chn))

"""
    device(chn)

Retrieves the corresponding `AbstractDeviceOrTrigger` for this channel.
"""
device(chn::AbstractChannel) = chn.dev

"""
    index(chn)

Returns the index of the channel.
"""
index(chn::AbstractChannel) = _channel_get_index(iio_channel(chn))

"""
    data_format(chn)

Returns the channel data format as a C-struct. See [`iio_data_format`](@ref).
"""
data_format(chn::AbstractChannel) = _channel_get_data_format(iio_channel(chn))

"""
    modifier(chn)::iio_modifier

Returns the channel modifier as an enum value.
"""
modifier(chn::AbstractChannel) = _channel_get_modifier(iio_channel(chn))

"""
    type(chn)::iio_chan_type

Returns the channel type as an enum value.
"""
type(chn::AbstractChannel) = _channel_get_type(iio_channel(chn))


"""
    Channel{T <: AbstractDeviceOrTrigger} <: AbstractChannel

Represents a channel of an IIO device.
"""
struct Channel{T <: AbstractDeviceOrTrigger} <: AbstractChannel
    channel::Ptr{iio_channel}
    dev::T
    attrs::Dict{String, ChannelAttr}
    id::String
    name::String
    output::Bool
    scan_element::Bool
end

"""
    Channel(dev::AbstractDeviceOrTrigger, channel::Ptr{iio_channel})

Initializes a new instance of the Channel type.

# Parameters
- `dev::AbstractDeviceOrTrigger` : The parent device handle (`Device` or `Trigger`)
- `channel::Ptr{iio_channel}` :  A valid pointer to an IIO channel.

# Returns
- A new instance of this type
"""
function Channel(dev::AbstractDeviceOrTrigger, channel::Ptr{iio_channel})
    attrs = Dict{String, ChannelAttr}(name => ChannelAttr(channel, name)
                                      for name in [_c_get_attr(channel,
                                                               convert(Cuint, x - 1))
                                                   for x in 1:_c_attr_count(channel)])
    id = _c_get_id(channel)
    name = _c_get_name(channel)
    output = _c_is_output(channel)
    scan_element = _c_is_scan_element(channel)

    return Channel(channel,
                   dev,
                   attrs,
                   id,
                   name,
                   output,
                   scan_element)
end
