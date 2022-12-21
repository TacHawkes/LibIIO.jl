"""
    iio_buffer_get_device(buffer)

Retrieves a pointer to the [`iio_device`](@ref) structure.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- A pointer to an [`iio_device`](@ref) structure

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga42367567d47f501d1922d1b331cf64fb)
"""
function iio_buffer_get_device(buffer::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_device, libiio),
                 Ptr{iio_device},
                 (Ptr{iio_device},),
                 buffer)
end

"""
    iio_device_create_buffer(dev, samples_count, cyclic)

Create an input or output buffer associated to the given device.

# Parameters
- `dev::Ptr{iio_device}` : A pointer to an [`iio_device`](@ref) structure
- `samples_count::Csize_t` : The number of samples that the buffer should contain
- `cyclic::Bool` : If true, enable cyclic mode

# Returns
- On success, a pointer to an [`iio_buffer`](@ref) structure
- On error, an error is raised

!!! note
    Channels that have to be written to / read from must be enabled before creating the buffer.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gaea8067aca27b93a1260a0c563607a501)
"""
function iio_device_create_buffer(dev::Ptr{iio_device}, samples_count::Csize_t,
                                  cyclic::Bool)
    return @check_null ccall((:iio_device_create_buffer, libiio),
                             Ptr{iio_buffer},
                             (Ptr{iio_device}, Csize_t, Cuchar),
                             dev, samples_count, cyclic)
end

"""
    iio_buffer_destroy(buf)

Destroy the given buffer.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- A pointer corresponding to the address that follows the last sample present in the buffer

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gaba58dc2780be63fead6f09397ce90d10)
"""
function iio_buffer_destroy(buf::Ptr{iio_buffer})
    ccall((:iio_buffer_destroy, libiio),
          Cvoid,
          (Ptr{iio_buffer},),
          buf)
end

"""
    iio_buffer_get_poll_fd(buf)

Get a pollable file descriptor.

Can be used to know when [`iio_buffer_refill`](@ref) or [`iio_buffer_push`](@ref) can be called

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- On success, valid file descriptor
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga2ae96ee9f0748e55dfad996d6e9883f2)
"""
function iio_buffer_get_poll_fd(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_poll_fd, libiio),
                 Cint,
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_set_blocking_mode(buf, blocking)

Make [`iio_buffer_refill`](@ref) and [`iio_buffer_push`](@ref) blocking or not.

After this function has been called with blocking == false, [`iio_buffer_refill`](@ref)
and [`iio_buffer_push`](@ref) will return `-EAGAIN` if no data is ready. A device is
blocking by default.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `blocking::Bool` : true if the buffer API should be blocking, else false

# Returns
- On success, 0
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gadf834d825ece149886283bcb8c2a5466)
"""
function iio_buffer_set_blocking_mode(buf::Ptr{iio_buffer}, blocking::Bool)
    return ccall((:iio_buffer_set_blocking_mode, libiio),
                 Cint,
                 (Ptr{iio_buffer}, Cuchar),
                 buf, blocking)
end

"""
    iio_buffer_refill(buf)

Fetch more samples from the hardware.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- On success, the number of bytes read is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gac999e5244b5a2cbbca5ecaef8303a4ff)
"""
function iio_buffer_refill(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_refill, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_push(buf)

Send the samples to the hardware.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- On success, the number of bytes written is returned
- On error, a negative errno code is returned

!!! note
    Only valid for output buffers

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gae7033c625d128667a56cf482aa3149bd)
"""
function iio_buffer_push(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_push, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_push_partial(buf, samples_count)

Send a given number of samples to the hardware.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `samples_count::Csize_t` : The number of samples to submit

# Returns
- On success, the number of bytes written is returned
- On error, a negative errno code is returned

!!! note
    Only valid for output buffers

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga367b7368532aebb35a0d56bccc550570)
"""
function iio_buffer_push_partial(buf::Ptr{iio_buffer}, samples_count::Csize_t)
    return ccall((:iio_buffer_push_partial, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer}, Csize_t),
                 buf, samples_count)
end

"""
    iio_buffer_cancel(buf)

Cancel all buffer operations.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

This function cancels all outstanding buffer operations previously scheduled.
This means any pending [`iio_buffer_push`](@ref) or [`iio_buffer_refill`](@ref)
operation will abort and return immediately, any further invocations of these functions
on the same buffer will return immediately with an error.

Usually [`iio_buffer_push`](@ref) and [`iio_buffer_refill`](@ref) will block until
either all data has been transferred or a timeout occurs. This can depending on the
configuration take a significant amount of time. [`iio_buffer_cancel`](@ref) is useful to
bypass these conditions if the buffer operation is supposed to be stopped in response to an
external event (e.g. user input).

To be able to capture additional data after calling this function the buffer should
be destroyed and then re-created.

This function can be called multiple times for the same buffer, but all but the first
invocation will be without additional effect.

This function is thread-safe, but not signal-safe, i.e. it must not be called
from a signal handler.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga0e42431688750313cfa077ab4f6e0282)
"""
function iio_buffer_cancel(buf::Ptr{iio_buffer})
    ccall((:iio_buffer_cancel, libiio),
          Cvoid,
          (Ptr{iio_buffer},),
          buf)
end

"""
    iio_buffer_start(buf)

Get the start address of the buffer.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- A pointer corresponding to the start address of the buffer

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga7fdacbfda79aa5120f34ea73ae2ea5ab)
"""
function iio_buffer_start(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_start, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_first(buf, chn)

Find the first sample of a channel in a buffer.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `chn::Ptr{iio_channel}` :A pointer to an [`iio_channel`](@ref) structure

# Returns
- A pointer to the first sample found, or to the end of the buffer if no sample for the given
  channel is present in the buffer

!!! note
    This function, coupled with iio_buffer_step and iio_buffer_end, can be used to
    iterate on all the samples of a given channel present in the buffer, doing the following:

    ```julia
    # Note that you have to adjust the end of the range for Julia, as the last value is included
    for ptr in iio_buffer_first(buf, chn):iio_buffer_step(buf):(iio_buffer_end(buf) - iio_buffer_step(buf))
        ....
    end
    ```

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga000d2f4c8b72060db1c38ec905bf4156)
"""
function iio_buffer_first(buf::Ptr{iio_buffer}, chn::Ptr{iio_channel})
    return ccall((:iio_buffer_first, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_channel}, Ptr{iio_channel}),
                 buf, chn)
end

"""
    iio_buffer_step(buf)

Get the step size between two samples of one channel.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- The difference between the addresses of two consecutive samples of one same channel

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga5532665a8776cec1c209d6cf8d0bb409)
"""
function iio_buffer_step(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_step, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_end(buf)

Get the address that follows the last sample in a buffer.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- A pointer corresponding to the address that follows the last sample present in the buffer

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gab5300f917bbdfc5dafc093a60138f131)
"""
function iio_buffer_end(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_end, libiio),
                 Ptr{Cuchar},
                 (Ptr{iio_buffer},),
                 buf)
end

"""
    iio_buffer_foreach_sample(buf, callback, data)

Call the supplied callback each sample found in a buffer.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `callback::Ptr{Cvoid}` : A pointer to a function to call for each sample found
- `data::Ptr{Cvoid}` : A user-specified pointer that will be passed to the callback

# Returns
- Number of bytes processed

!!! note
    The callback receives four arguments:

    - A pointer to the [`iio_channel`](@ref) structure corresponding to the sample,
    - A pointer to the sample itself,
    - The length of the sample in bytes,
    - The user-specified pointer passed to [`iio_buffer_foreach_sample`](@ref).

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga810ec50155e82331b18ec71d3c507104)
"""
function iio_buffer_foreach_sample(buf::Ptr{iio_buffer}, callback::Ptr{Cvoid},
                                   data::Ptr{Cvoid})
    return ccall((:iio_buffer_foreach_sample, libiio),
                 Cssize_t,
                 (Ptr{iio_buffer}, Ptr{Cvoid}, Ptr{Cvoid}),
                 buf, callback, data)
end

"""
    iio_buffer_set_data(buf, data)

Associate a pointer to an [`iio_buffer`](@ref) structure.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure
- `data::Ptr{Cuchar}` : The pointer to be associated

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#ga07f485e4e2de57c8c1cd0141611187dc)
"""
function iio_buffer_set_data(buf::Ptr{iio_buffer}, data::Ptr{Cuchar})
    return ccall((:iio_buffer_set_data, libiio),
                 Cvoid,
                 (Ptr{iio_buffer}, Ptr{Cuchar}),
                 buf, data)
end

"""
    iio_buffer_get_data(buf)

Retrieve a pointer to the [`iio_device`](@ref) structure.

# Parameters
- `buf::Ptr{iio_buffer}` : A pointer to an [`iio_buffer`](@ref) structure

# Returns
- A pointer to an [`iio_device`](@ref) structure

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Buffer.html#gac110da795a50dc45fe998cace656329b)
"""
function iio_buffer_get_data(buf::Ptr{iio_buffer})
    return ccall((:iio_buffer_get_data, libiio),
                 Ptr{iio_device},
                 (Ptr{iio_buffer},),
                 buf)
end
