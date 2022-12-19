context(ctx::AbstractContext) = ctx.context

"""
    set_timeout(ctx::AbstractContext, timeout)

Set a timeout for I/O operations.

# Parameters
- `value` : The timeout value, in milliseconds
"""
set_timeout(ctx::AbstractContext, timeout) = _set_timeout(context(ctx), timeout)

"""
    clone(ctx::T) where {T <: AbstractContext}

Clones the IIO context.
"""
clone(ctx::T) where {T <: AbstractContext} = T(_clone(context(ctx)))

"""
    name(ctx::AbstractContext)

Name of the IIO context.
"""
name(ctx::AbstractContext) = ctx.name

"""
    description(ctx::AbstractContext)

Description of this IIO context.
"""
description(ctx::AbstractContext) = ctx.description

"""
    xml(ctx::AbstractContext)

XML representation of the IIO context.
"""
xml(ctx::AbstractContext) = ctx.xml_file

"""
    version(ctx::AbstractContext)

Version of the context backed, as `Tuple(UInt, UInt, String)``
"""
version(ctx::AbstractContext) = ctx.version

"""
    attrs(ctx::AbstractContext)

Lost of context-specific attributes.
"""
attrs(ctx::AbstractContext) = ctx.attrs

"""
    find_device(ctx::AbstractContext, name_or_id_or_label)

Find an IIO device by its name, ID or label.
"""
function find_device(ctx::AbstractContext, name_or_id_or_label)
    dev = _find_device(context(ctx), name_or_id_or_label)
    return _d_is_trigger(dev) ? Trigger(ctx, dev) : Device(ctx, dev)
end

"""
    devices(ctx::AbstractContext)

List of devices contained in this context.
"""
function devices(ctx::AbstractContext)
    return [(_d_is_trigger(dev) ? Trigger(ctx, dev) : Device(ctx, dev))
            for dev in [_get_device(context(ctx), convert(Cuint, x - 1))
                        for x in 1:_devices_count(context(ctx))]]
end

function show(io::IO, ctx::AbstractContext)
    _ctx = context(ctx)
    name = _get_name(_ctx)
    println(io, "IIO context created with ", name, " backend.")
    ret, major, minor, git_tag = _get_version(_ctx)
    if ret == 0
        println(io, "Backend version: $major.$minor (git tag: $git_tag)")
    else
        err_str = iio_strerror(-ret)
        println(io, "Unable to get backend version: $err_str")
    end

    println(io, "Backend description string: $(_get_description(_ctx))")

    nb_ctx_attrs = _get_attrs_count(_ctx)
    nb_ctx_attrs > 0 && println(io, "IIO context has $nb_ctx_attrs attributes:")

    for i in 0:(nb_ctx_attrs - 1)
        ret, name, value = _get_attr(_ctx, convert(Cuint, i))
        if ret == 0
            println(io, "\t$name: $value")
        else
            err_str = iio_strerror(-ret)
            println(io, "\tUnable to read IIO context attributes: $err_str")
        end
    end

    nb_devices = _devices_count(_ctx)
    println(io, "IIO context has $nb_devices devices:")

    devs = devices(ctx)
    for dev in devs
        show(io, dev)
    end
end

"""
Contains the representation of an IIO context.
"""
mutable struct Context <: AbstractContext
    context::Ptr{iio_context}
    name::String
    description::String
    xml::String
    version::Tuple{Int, Int, String}
    attrs::Dict{String, String}
end

"""
    Context(context = nothing)

Initializes a new Context using the local or the network backend of the IIO library.

This function will create a network context if the IIOD_REMOTE
environment variable is set to the hostname where the IIOD server runs.
If set to an empty string, the server will be discovered using ZeroConf.
If the environment variable is not set, a local context will be created instead.
"""
function Context(context = nothing)
    # init context
    ctx = init_ctx(context)

    # init attributes
    attrs = Dict{String, String}()
    for index in 1:_get_attrs_count(ctx)
        ret, name, value = _get_attr(ctx, convert(Cuint, index - 1))
        push!(attrs, name => value)
    end

    name = _get_name(ctx)
    description = _get_description(ctx)
    xml = _get_xml(ctx)
    ret, major, minor, git_tag = _get_version(ctx)

    _context = Context(ctx,
                       name,
                       description,
                       xml,
                       (major, minor, git_tag),
                       attrs)

    # register finalizer
    finalizer(_context) do x
        _destroy(x.context)
    end
end
init_ctx(ctx::Ptr{iio_context}) = ctx
init_ctx(ctx::String) = _new_uri(ctx)
init_ctx(::Nothing) = _new_default()

abstract type AbstractBackendContext <: AbstractContext end
context(ctx::AbstractBackendContext) = context(ctx.context)
name(ctx::AbstractBackendContext) = name(ctx.context)
description(ctx::AbstractBackendContext) = description(ctx.context)
xml(ctx::AbstractBackendContext) = xml(ctx.context)
version(ctx::AbstractBackendContext) = version(ctx.context)
attrs(ctx::AbstractBackendContext) = attrs(ctx.context)

"""
Local IIO Context.
"""
struct LocalContext <: AbstractBackendContext
    context::Context
end

"""
    LocalContext([ctx::Ptr{iio_context}])

Initializes a new LocalContext using the local backend if the IIO library.
Can be constructed from an existing pointer to an `iio_context`.
"""
function LocalContext()
    ctx = _new_local()
    return LocalContext(Context(ctx))
end
LocalContext(ctx::Ptr{iio_context}) = LocalContext(Context(ctx))

"""
XML IIO Context.
"""
struct XMLContext <: AbstractBackendContext
    context::Context
end

"""
    XMLContext(xml_file)

Initializes a new XMLContext using the XML backend if the IIO library.

# Parameters
- `xmlfile` : Filename of the XML file to build the context from.
"""
function XMLContext(xmlfile::String)
    ctx = _new_xml(xmlfile)
    return XMLContext(Context(ctx))
end
XMLContext(ctx::Ptr{iio_context}) = XMLContext(Context(ctx))

"""
Network IIO context
"""
struct NetworkContext <: AbstractBackendContext
    context::Context
end

"""
    XMLContext(xml_file)

Initializes a new NetworkContext using the network backend if the IIO library.

# Parameters
- `hostname` : Hostname, IPv4 or IPv6 address where the IIO Daemon is running
"""
function NetworkContext(hostname::Union{String, Nothing} = nothing)
    ctx = !isnothing(hostname) ? _new_network(hostname) : nothing
    return NetworkContext(Context(ctx))
end
NetworkContext(ctx::Ptr{iio_context}) = NetworkContext(Context(ctx))

"""
    scan_contexts()

Scan Context.
"""
function scan_contexts()
    scan_ctx = Dict{String, String}()
    ptr = Ptr{Ptr{iio_context_info}}()
    ctx = _create_scan_context("")
    ctx_nb = _get_context_info_list(ctx, Ref(ptr))

    for i in 1:ctx_nb
        scan_ctx[_context_info_get_uri(unsafe_load(ptr, i))] = _context_info_get_description(unsafe_load(ptr, i))
    end

    _context_info_list_free(ptr)
    _destroy_scan_context(ctx)

    return scan_ctx
end
