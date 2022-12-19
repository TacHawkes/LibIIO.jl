"""
    DeviceAttr <: Attr

Represents an attribute of an IIO device
"""
struct DeviceAttr <: Attr
    device::Ptr{iio_device}
    name::String
end
filename(a::DeviceAttr) = a.name
read(a::DeviceAttr) = _d_read_attr(a.device, a.name)
write(a::DeviceAttr, value) = _d_write_attr(a.device, a.name, value)

"""
    DeviceAttr <: Attr

Represents a debug attribute of an IIO device
"""
struct DeviceDebugAttr <: Attr
    device::Ptr{iio_device}
    name::String
end
filename(a::DeviceDebugAttr) = a.name
read(a::DeviceDebugAttr) = _d_read_debug_attr(a.device, a.name)
write(a::DeviceDebugAttr, value) = _d_write_debug_attr(a.device, a.name, value)

"""
    DeviceAttr <: Attr

Represents a buffer attribute of an IIO device
"""
struct DeviceBufferAttr <: Attr
    device::Ptr{iio_device}
    name::String
end
filename(a::DeviceBufferAttr) = a.name
read(a::DeviceBufferAttr) = _d_read_buffer_attr(a.device, a.name)
write(a::DeviceBufferAttr, value) = _d_write_buffer_attr(a.device, a.name, value)

device_or_trigger(d::AbstractDeviceOrTrigger) = d

"""
    id(d::AbstractDeviceOrTrigger)

An identifier of the device, only valid in this IIO context.
"""
id(d::AbstractDeviceOrTrigger) = device_or_trigger(d).id

"""
    name(d::AbstractDeviceOrTrigger)

The name of the device.
"""
name(d::AbstractDeviceOrTrigger) = device_or_trigger(d).name

"""
    label(d::AbstractDeviceOrTrigger)

The label of the device.
"""
label(d::AbstractDeviceOrTrigger) = device_or_trigger(d).label

"""
    attrs(d::AbstractDeviceOrTrigger)

List of attributes for the IIO device.
"""
attrs(d::AbstractDeviceOrTrigger) = device_or_trigger(d).attrs

"""
    debug_attrs(d::AbstractDeviceOrTrigger)

List of debug attributes for the IIO device.
"""
debug_attrs(d::AbstractDeviceOrTrigger) = device_or_trigger(d).debug_attrs

"""
    buffer_attrs(d::AbstractDeviceOrTrigger)

List of buffer attributes for the IIO device.
"""
buffer_attrs(d::AbstractDeviceOrTrigger) = device_or_trigger(d).buffer_attrs

"""
    channels(d::AbstractDeviceOrTrigger)

List of channels available with this IIO device.
"""
function channels(d::AbstractDeviceOrTrigger)
    _dt = device_or_trigger(d)
    chns = [Channel(_dt,
                    _get_channel(_dt.device, convert(Cuint, x - 1)))
            for x in 1:_channels_count(_dt.device)]
    sort!(chns, by = x -> id(x))

    return chns
end

"""
    reg_write(d::AbstractDeviceOrTrigger, reg, value)

Set a valie to one register of the device.

# Parameters
- `d` : The device instance
- `reg` : The register address
- `value` ; The value that will be used for this register
"""
function reg_write(d::AbstractDeviceOrTrigger, reg, value)
    _d_reg_write(device_or_trigger(d).device, reg, value)
end

"""
    reg_read(d::AbstractDeviceOrTrigger, reg)

Read the content of a register of this device.

# Parameters
- `d` : The device instance
- `reg` : The register address

# Returns
- The value of the register
"""
reg_read(d::AbstractDeviceOrTrigger, reg) = _d_reg_read(device_or_trigger(d).device, reg)

"""
    find_channel(d::AbstractDeviceOrTrigger, name_or_id, is_output = false)

Find an IIO channel by its name or ID.

# Parameters
- `d` : The device instance
- `name_or_id` : The name or ID of the channel to find
- `is_output` : Set to true to search for an output channel

# Returns
- The IIO channel as `Channel`
"""
function find_channel(d::AbstractDeviceOrTrigger, name_or_id, is_output = false)
    chn = _d_find_channel(device_or_trigger(d).device, name_or_id, is_output)
    return chn == C_NULL ? nothing : Channel(d, chn)
end

"""
    set_kernel_buffers_count(d::AbstractDeviceOrTrigger, count)

Set the number of kernel buffers to use with the specified device

# Parameters
- `d` : The device instance
- `count` : The number of kernel buffers
"""
function set_kernel_buffers_count(d::AbstractDeviceOrTrigger, count)
    _d_set_buffers_count(device_or_trigger(d).device, count)
end

"""
    sample_size(d::AbstractDeviceOrTrigger)

Sample size of the device.
The sample size varies each time channels get enabled or disabled.
"""
sample_size(d::AbstractDeviceOrTrigger) = _get_sample_size(device_or_trigger(d).device)

function show(io::IO, dev::AbstractDeviceOrTrigger)
    d_o_t = device_or_trigger(dev)
    _dev = d_o_t.device
    _name = name(dev)
    _label = label(dev)
    _id = id(dev)
    print(io, "\t$_id:")
    !isempty(_name) && print(io, " $_name")
    !isempty(_label) && print(io, " (label: $_label")
    dev_is_buffer_capable(_dev) && print(io, " (buffer capable)")
    println(io)

    nb_channels = _channels_count(_dev)
    println(io, "\t\t$nb_channels channels found:")

    chns = channels(dev)
    for chn in chns
        show(io, chn)
    end

    nb_attrs = _d_attr_count(_dev)
    if nb_attrs > 0
        println(io, "\t\t$nb_attrs device-specific attributes found:")

        j = 0
        for (_name, attr) in attrs(dev)
            show(io, attr, j)

            j += 1
        end
    end

    nb_attrs = _d_buffer_attr_count(_dev)
    if nb_attrs > 0
        println(io, "\t\t$nb_attrs buffer-specific attributes found:")

        j = 0
        for (_name, attr) in buffer_attrs(dev)
            show(io, attr, j)

            j += 1
        end
    end

    nb_attrs = _d_debug_attr_count(_dev)
    if nb_attrs > 0
        println(io, "\t\t$nb_attrs debug-specific attributes found:")

        j = 0
        for (_name, attr) in debug_attrs(dev)
            show(io, attr, j)

            j += 1
        end
    end

    ret, trig = _d_get_trigger(_dev)
    if ret == 0
        if trig == C_NULL
            println(io, "\t\tNo trigger assigned to device")
        else
            _name = _d_get_name(trig)
            _id = _d_get_id(trig)
            println("\t\tCurrent trigger: $_name($_id)")
        end
    elseif ret == -ENOENT
        println(io, "\t\tNo trigger on this device")
    elseif ret < 0
        err_str = iio_strerror(-ret)
        println("ERROR: checking for trigger : $err_str")
    end
end

struct DeviceOrTrigger{T <: AbstractContext} <: AbstractDeviceOrTrigger
    ctx::T
    context::Ptr{iio_context}
    device::Ptr{iio_device}
    attrs::Dict{String, DeviceAttr}
    debug_attrs::Dict{String, DeviceDebugAttr}
    buffer_attrs::Dict{String, DeviceBufferAttr}
    id::String
    name::String
    label::String
end

function DeviceOrTrigger(ctx::AbstractContext, device::Ptr{iio_device})
    context = _d_get_context(device)
    attrs = Dict{String, DeviceAttr}(name => DeviceAttr(device, name)
                                     for name in [_d_get_attr(device,
                                                              convert(Cuint, x - 1))
                                                  for x in 1:_d_attr_count(device)])
    debug_attrs = Dict{String, DeviceDebugAttr}(name => DeviceDebugAttr(device, name)
                                                for name in [_d_get_debug_attr(device,
                                                                               convert(Cuint,
                                                                                       x -
                                                                                       1))
                                                             for x in 1:_d_debug_attr_count(device)])
    buffer_attrs = Dict{String, DeviceBufferAttr}(name => DeviceBufferAttr(device, name)
                                                  for name in [_d_get_buffer_attr(device,
                                                                                  convert(Cuint,
                                                                                          x -
                                                                                          1))
                                                               for x in 1:_d_buffer_attr_count(device)])

    id = _d_get_id(device)
    name = _d_get_name(device)
    label = _d_get_label(device)

    return DeviceOrTrigger(ctx,
                           context,
                           device,
                           attrs,
                           debug_attrs,
                           buffer_attrs,
                           id,
                           name,
                           label)
end

"""
Contains the representation of an IIO device that can act as a trigger.
"""
struct Trigger{T <: AbstractContext} <: AbstractDeviceOrTrigger
    trigger::DeviceOrTrigger{T}
end

"""
    Trigger(ctx::AbstractContext, device::Ptr{iio_device})

Initializes a new Trigger instance.

# Parameters
- `ctx` : The IIO context instance with which the device is accessed
- `device` : A pointer to an iio_device which represents this trigger
"""
function Trigger(ctx::AbstractContext, device::Ptr{iio_device})
    return Trigger(DeviceOrTrigger(ctx, device))
end
device_or_trigger(t::Trigger) = t.trigger

"""
    frequency(t::Trigger)

Configured frequency (in Hz) of the trigger.
"""
frequency(t::Trigger) = parse(Int, read(attrs(t)["sampling_frequency"]))

"""
    frequency!(t::Trigger, value)

Set the trigger rate.
"""
frequency!(t::Trigger, value) = write(attrs(t)["sampling_frequency"], string(value))

"""
Contains the representation of an IIO device.
"""
struct Device{T <: AbstractContext} <: AbstractDeviceOrTrigger
    device::DeviceOrTrigger{T}
end

"""
    Device(ctx::AbstractContext, device::Ptr{iio_device})

Initializes a new Device instance.

# Parameters
- `ctx` : The IIO context instance with which the device is accessed
- `device` : A pointer to an iio_device which represents this device
"""
function Device(ctx::AbstractContext, device::Ptr{iio_device})
    return Device(DeviceOrTrigger(ctx, device))
end
device_or_trigger(d::Device) = d.device
hwmon(d::Device) = error("TODO")

"""
    context(d::Device)

Context for the device.
"""
context(d::Device) = device_or_trigger(d).ctx

"""
    trigger!(d::Device, trigger::Trigger)

Sets the configured trigger for this IIO device.
"""
function trigger!(d::Device, trigger::Trigger)
    _d_set_trigger(d.device.device, trigger.device.device)
end

"""
    trigger(d::Device)

Returns the configured trigger for this IIO device, if present in the current context.
"""
function trigger(d::Device)
    ret, _trig = _d_get_trigger(d.device.device)
    trig = Trigger(context(d), _trig)

    for dev in devices(context(d))
        if id(trig.id) == id(dev)
            return dev
        end
    end

    return nothing
end
