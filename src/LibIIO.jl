module LibIIO

include("clib/CLibIIO.jl")
using .CLibIIO
import .CLibIIO: iio_context, iio_device, iio_channel, iio_buffer, iio_context_info, iio_scan_context, iio_scan_block

import Base: read, write, show

const ENOENT = -34

include("types.jl")
include("alias.jl")
include("attrs.jl")
include("channel.jl")
include("buffer.jl")
include("device.jl")
include("context.jl")

export Context,
    LocalContext,
    XMLContext,
    NetworkContext,
    Buffer,
    Device,
    Channel,
    Trigger,
    name,
    id,
    label,
    attrs,
    buffer_attrs,
    debug_attrs,
    description,
    xml,
    find_channel,
    find_device,
    devices,
    channels,
    enabled,
    enabled!,
    push,
    refill
end
