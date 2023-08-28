module CLibIIO

using libiio_jll
const libiio = libiio_jll.libiio

const BUF_SIZE = 16384
const DST_BUFFER = Vector{Cchar}(undef, BUF_SIZE)

include("ctypes.jl")
export iio_scan_context,
       iio_scan_block,
       iio_context_info,
       iio_context,
       iio_device,
       iio_channel,
       iio_buffer,
       iio_data_format,
       iio_modifier,
       iio_chan_type

# enum exports
for s in instances(iio_modifier)
    @eval export $(Symbol(s))
end
for s in instances(iio_chan_type)
    @eval export $(Symbol(s))
end

include("util.jl")
export dev_is_buffer_capable

include("scan.jl")
export iio_context_info_get_description,
       iio_context_info_get_uri,
       iio_context_info_list_free,
       iio_create_scan_block,
       iio_create_scan_context,
       iio_scan_block_destroy,
       iio_scan_block_get_info,
       iio_scan_block_scan,
       iio_scan_context_destroy,
       iio_scan_context_get_info_list

include("toplevel.jl")
export iio_get_backend,
       iio_get_backends_count,
       iio_has_backend,
       iio_library_get_version,
       iio_strerror

include("context.jl")
export iio_context_clone,
       iio_context_destroy,
       iio_context_find_device,
       iio_context_get_attr,
       iio_context_get_attr_value,
       iio_context_get_attrs_count,
       iio_context_get_description,
       iio_context_get_device,
       iio_context_get_devices_count,
       iio_context_get_name,
       iio_context_get_version,
       iio_context_get_xml,
       iio_context_set_timeout,
       iio_create_context_from_uri,
       iio_create_default_context,
       iio_create_local_context,
       iio_create_network_context,
       iio_create_xml_context,
       iio_create_xml_context_mem

include("device.jl")
export iio_device_attr_read,
       iio_device_attr_read_all,
       iio_device_attr_read_bool,
       iio_device_attr_read_double,
       iio_device_attr_read_longlong,
       iio_device_attr_write,
       iio_device_attr_write_all,
       iio_device_attr_write_bool,
       iio_device_attr_write_double,
       iio_device_attr_write_longlong,
       iio_device_attr_write_raw,
       iio_device_buffer_attr_read,
       iio_device_buffer_attr_read_all,
       iio_device_buffer_attr_read_bool,
       iio_device_buffer_attr_read_double,
       iio_device_buffer_attr_read_longlong,
       iio_device_buffer_attr_write,
       iio_device_buffer_attr_write_all,
       iio_device_buffer_attr_write_bool,
       iio_device_buffer_attr_write_double,
       iio_device_buffer_attr_write_longlong,
       iio_device_buffer_attr_write_raw,
       iio_device_find_attr,
       iio_device_find_buffer_attr,
       iio_device_find_channel,
       iio_device_get_attr,
       iio_device_get_attrs_count,
       iio_device_get_buffer_attr,
       iio_device_get_buffer_attrs_count,
       iio_device_get_channel,
       iio_device_get_channels_count,
       iio_device_get_context,
       iio_device_get_data,
       iio_device_get_id,
       iio_device_get_name,
       iio_device_get_label,
       iio_device_get_trigger,
       iio_device_is_trigger,
       iio_device_set_data,
       iio_device_set_kernel_buffers_count,
       iio_device_set_trigger

include("channel.jl")
export iio_channel_attr_get_filename,
       iio_channel_attr_read,
       iio_channel_attr_read_all,
       iio_channel_attr_read_bool,
       iio_channel_attr_read_double,
       iio_channel_attr_read_longlong,
       iio_channel_attr_write,
       iio_channel_attr_write_all,
       iio_channel_attr_write_bool,
       iio_channel_attr_write_double,
       iio_channel_attr_write_longlong,
       iio_channel_attr_write_raw,
       iio_channel_disable,
       iio_channel_enable,
       iio_channel_find_attr,
       iio_channel_get_attr,
       iio_channel_get_attrs_count,
       iio_channel_get_data,
       iio_channel_get_device,
       iio_channel_get_id,
       iio_channel_get_modifier,
       iio_channel_get_name,
       iio_channel_get_type,
       iio_channel_is_enabled,
       iio_channel_is_output,
       iio_channel_is_scan_element,
       iio_channel_read,
       iio_channel_read_raw,
       iio_channel_set_data,
       iio_channel_write,
       iio_channel_write_raw

include("buffer.jl")
export iio_buffer_cancel,
       iio_buffer_destroy,
       iio_buffer_end,
       iio_buffer_first,
       iio_buffer_foreach_sample,
       iio_buffer_get_data,
       iio_buffer_get_device,
       iio_buffer_get_poll_fd,
       iio_buffer_push,
       iio_buffer_push_partial,
       iio_buffer_refill,
       iio_buffer_set_blocking_mode,
       iio_buffer_set_data,
       iio_buffer_start,
       iio_buffer_step,
       iio_device_create_buffer

include("debug.jl")
export iio_device_get_sample_size,
       iio_channel_get_index,
       iio_channel_get_data_format,
       iio_channel_convert,
       iio_channel_convert_inverse,
       iio_device_get_debug_attrs_count,
       iio_device_get_debug_attr,
       iio_device_find_debug_attr,
       iio_device_debug_attr_read,
       iio_device_debug_attr_read_all,
       iio_device_debug_attr_write,
       iio_device_debug_attr_write_raw,
       iio_device_debug_attr_write_all,
       iio_device_debug_attr_read_bool,
       iio_device_debug_attr_read_longlong,
       iio_device_debug_attr_read_double,
       iio_device_debug_attr_write_bool,
       iio_device_debug_attr_write_longlong,
       iio_device_debug_attr_write_double,
       iio_device_identify_filename,
       iio_device_reg_write,
       iio_device_reg_read
end
