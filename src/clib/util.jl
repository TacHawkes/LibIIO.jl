function iio_parse_attr(buffer::Vector{Cchar}, size::Cssize_t)
    # prepare output
    attributes = Tuple{Int, String}[]
    parsed = 0
    while parsed < size
        index = parsed + 1
        block_prefix = reinterpret(Int32, ntoh(buffer[index:(index + 3)]))

        if block_prefix < 0
            # error
            push!(attributes, (block_prefix, ""))
            parsed += 4
        else
            # success (and Julia can do pointer arithmetics :)
            push!(attributes, (block_prefix, unsafe_string(pointer(buffer) + (4 + parsed))))
            parsed += 4 + block_prefix
        end
    end

    return attributes
end

function dev_is_buffer_capable(dev::Ptr{iio_device})
    for i in 0:(iio_device_get_channels_count(dev) - 1)
        chn = iio_device_get_channel(dev, convert(Cuint, i))
        iio_channel_is_scan_element(chn) && return true
    end

    return false
end
