#=

Aliases matching the Python bindings
=#

const _get_backends_count = iio_get_backends_count
const _get_backend = iio_get_backend
const _create_scan_context = iio_create_scan_context
const _destroy_scan_context = iio_scan_context_destroy
const _has_backend = iio_has_backend
const _get_context_info_list = iio_scan_context_get_info_list
const _context_info_list_free = iio_context_info_list_free
const _context_info_get_description = iio_context_info_get_description
const _context_info_get_uri = iio_context_info_get_uri
const _new_local = iio_create_local_context
const _new_xml = iio_create_xml_context
const _new_network = iio_create_network_context
const _new_default = iio_create_default_context
const _new_uri = iio_create_context_from_uri
const _destroy = iio_context_destroy
const _get_name = iio_context_get_name
const _get_description = iio_context_get_description
const _get_xml = iio_context_get_xml
const _get_library_version = iio_library_get_version
const _get_version = iio_context_get_version
const _get_attrs_count = iio_context_get_attrs_count
const _get_attr = iio_context_get_attr
const _devices_count = iio_context_get_devices_count
const _get_device = iio_context_get_device
const _find_device = iio_context_find_device
const _set_timeout = iio_context_set_timeout
const _clone = iio_context_clone
const _d_get_id = iio_device_get_id
const _d_get_name = iio_device_get_name
const _d_get_label = iio_device_get_label
const _d_attr_count = iio_device_get_attrs_count
const _d_get_attr = iio_device_get_attr
const _d_read_attr = iio_device_attr_read
const _d_write_attr = iio_device_attr_write
const _d_debug_attr_count = iio_device_get_debug_attrs_count
const _d_get_debug_attr = iio_device_get_debug_attr
const _d_read_debug_attr = iio_device_debug_attr_read
const _d_write_debug_attr = iio_device_debug_attr_write
const _d_buffer_attr_count = iio_device_get_buffer_attrs_count
const _d_get_buffer_attr = iio_device_get_buffer_attr
const _d_read_buffer_attr = iio_device_buffer_attr_read
const _d_write_buffer_attr = iio_device_attr_write
const _d_get_context = iio_device_get_context
const _d_find_channel = iio_device_find_channel
const _d_reg_write = iio_device_reg_write
const _d_reg_read = iio_device_reg_read
const _channels_count = iio_device_get_channels_count
const _get_channel = iio_device_get_channel
const _get_sample_size = iio_device_get_sample_size
const _d_is_trigger = iio_device_is_trigger
const _d_get_trigger = iio_device_get_trigger
const _d_set_trigger = iio_device_set_trigger
const _d_set_buffers_count = iio_device_set_kernel_buffers_count
const _c_get_id = iio_channel_get_id
const _c_get_name = iio_channel_get_name
const _c_is_output = iio_channel_is_output
const _c_is_scan_element = iio_channel_is_scan_element
const _c_attr_count = iio_channel_get_attrs_count
const _c_get_attr = iio_channel_get_attr
const _c_get_filename = iio_channel_attr_get_filename
const _c_read_attr = iio_channel_attr_read
const _c_write_attr = iio_channel_attr_write
const _c_enable = iio_channel_enable
const _c_disable = iio_channel_disable
const _c_is_enabled = iio_channel_is_enabled
const _c_read = iio_channel_read
const _c_read_raw = iio_channel_read_raw
const _c_write = iio_channel_write
const _c_write_raw = iio_channel_write_raw
const _channel_get_device = iio_channel_get_device
const _channel_get_index = iio_channel_get_index
const _channel_get_data_format = iio_channel_get_data_format
const _channel_get_modifier = iio_channel_get_modifier
const _channel_get_type = iio_channel_get_type
const _create_buffer = iio_device_create_buffer
const _buffer_destroy = iio_buffer_destroy
const _buffer_refill = iio_buffer_refill
const _buffer_push_partial = iio_buffer_push_partial
const _buffer_start = iio_buffer_start
const _buffer_end = iio_buffer_end
const _buffer_cancel = iio_buffer_cancel
const _buffer_get_device = iio_buffer_get_device
const _buffer_get_poll_fd = iio_buffer_get_poll_fd
const _buffer_step = iio_buffer_step
const _buffer_set_blocking_mode = iio_buffer_set_blocking_mode
