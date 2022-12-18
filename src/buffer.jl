import Base: length

mutable struct Buffer{T <: AbstractDeviceOrTrigger} <: AbstractBuffer
    buffer::Ptr{iio_buffer}
    length::Int
    samples_count::Int
    dev::T
end

function Buffer(device::T, samples_count, cyclic::Bool=false) where T <: AbstractDeviceOrTrigger
    buf = _create_buffer(device_or_trigger(device).device, convert(Csize_t, samples_count), cyclic)

    buffer = Buffer(
        buf,
        samples_count * sample_size(device),
        samples_count,
        device
    )
    finalizer(buffer) do x
        _buffer_destroy(x.buffer)
    end
    return buffer
end

length(buf::Buffer) = buf.length
refill(buf::Buffer) = _buffer_refill(buf.buffer)
push(buf::Buffer) = _buffer_push_partial(buf.buffer, convert(Csize_t, buf.samples_count))
push(buf::Buffer, samples_count) = _buffer_push_partial(buf.buffer, convert(Csize_t, samples_count))

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

function write(buf::Buffer, array::Vector{T}) where T
    _array = reinterpret(Cuchar, array)
    _start = _buffer_start(buf.buffer)
    _end = _buffer_end(buf.buffer)
    len = _end - _start
    (len > length(_array)) && (len = length(_array))
    n = len * Base.aligned_sizeof(Cuchar)
    src = Ptr{Cuchar}(_start)
    unsafe_copyto!(src, pointer(_array), n)

    return len
end

cancel(buf::Buffer) = _buffer_cancel(buf.buffer)
set_blocking_mode(buf::Buffer, blocking) = _buffer_set_blocking_mode(buf.buffer, blocking)
device(buf::Buffer) = buf.dev
poll_fd(buf::Buffer) = _buffer_get_poll_fd(buf.buffer)
step(buf::Buffer) = _buffer_step(buf.buffer)
