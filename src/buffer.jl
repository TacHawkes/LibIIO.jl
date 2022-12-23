import Base: length

"""
This class is used for all I/O operations of buffer capable devices.
"""
mutable struct Buffer{T <: AbstractDeviceOrTrigger} <: AbstractBuffer
    buffer::Ptr{iio_buffer}
    length::Int
    samples_count::Int
    dev::T
end

"""
    Buffer(device::T, samples_count, cyclic::Bool = false) where {T <: AbstractDeviceOrTrigger}

Initializes a new Buffer instance.

# Parameters
- `device::AbstractDeviceOrTrigger` :  A device instance (either [`Device`](@ref) or [`Trigger`](@ref) to which the buffer belongs
- `samples_count` : The size of the buffer in samples
- `cyclic` : If set to true, the buffer is circular
"""
function Buffer(device::T, samples_count,
                cyclic::Bool = false) where {T <: AbstractDeviceOrTrigger}
    buf = _create_buffer(device_or_trigger(device).device, convert(Csize_t, samples_count),
                         cyclic)

    buffer = Buffer(buf,
                    samples_count * sample_size(device),
                    samples_count,
                    device)

    # register finalizer
    finalizer(buffer) do x
        _buffer_destroy(x.buffer)
    end
    return buffer
end

"""
    length(buf::Buffer)

Size of this buffer, in bytes.
"""
length(buf::Buffer) = buf.length

"""
    refill(buf::Buffer)

Fetch a new set of samples from the hardware.
"""
refill(buf::Buffer) = _buffer_refill(buf.buffer)

"""
    push(buf::Buffer [, samples_count])

Submit the samples contained in this buffer to the hardware.

# Parameters
- `buf::Buffer` : The buffer struct
- `samples_count` (optional) : The number of samples to submit, default = full buffer
"""
push(buf::Buffer) = _buffer_push_partial(buf.buffer, convert(Csize_t, buf.samples_count))
function push(buf::Buffer, samples_count)
    _buffer_push_partial(buf.buffer, convert(Csize_t, samples_count))
end

"""
    read(buf::Buffer)

Retrieves the samples contained inside the Buffer.

# Returns
- A `Vector{Cuchar}` containing the samples
"""
function read(buf::Buffer)
    _start = _buffer_start(buf.buffer)
    _end = _buffer_end(buf.buffer)
    len = _end - _start
    src = Ptr{Cuchar}(_start)
    dst = Vector{Cuchar}(undef, len)
    n = len * Base.aligned_sizeof(Cuchar)
    unsafe_copyto!(pointer(dst), src, n)

    return dst
end

"""
    write(buf::Buffer, data::Vector{T}) where {T}

Copy the given vector of samples into the buffer

# Parameters
- `data` : The data vector containing the samples to copy

# Returns
- The number of bytes written into the buffer
"""
function write(buf::Buffer, data::Vector{T}) where {T}
    _data = reinterpret(Cuchar, data)
    _start = _buffer_start(buf.buffer)
    _end = _buffer_end(buf.buffer)
    len = _end - _start
    (len > length(_data)) && (len = length(_data))
    n = len * Base.aligned_sizeof(Cuchar)
    src = Ptr{Cuchar}(_start)
    unsafe_copyto!(src, pointer(_data), n)

    return len
end

"""
    cancel(buf::Buffer)

Cancel the current buffer.
"""
cancel(buf::Buffer) = _buffer_cancel(buf.buffer)

"""
    set_blocking_mode(buf::Buffer, blocking)

Set the buffer's blocking mode.

# Parameters:
- `blocking` : True if in blocking mode else false.
"""
set_blocking_mode(buf::Buffer, blocking) = _buffer_set_blocking_mode(buf.buffer, blocking)

"""
    device(buf::Buffer)

[`Device`](@ref) for the buffer.
"""
device(buf::Buffer) = buf.dev

"""
    poll_fd(buf::Buffer)

Poll_fd for the buffer.
"""
poll_fd(buf::Buffer) = _buffer_get_poll_fd(buf.buffer)

"""
    step(buf::Buffer)

Step size for the buffer.
"""
step(buf::Buffer) = _buffer_step(buf.buffer)
