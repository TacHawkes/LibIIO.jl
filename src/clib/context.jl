"""
    iio_create_default_context()

Create a context from local or remote IIO devices.

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

**NOTE:** This function will create a context with the URI provided in the IIOD_REMOTE
          environment variable. If not set, a local context will be created instead.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga21076125f817a680e0c01d4a490f0416)
"""
function iio_create_default_context()
    return @check_null ccall((:iio_create_default_context, libiio),
                             Ptr{iio_context},
                             ())
end

"""
    iio_create_local_context()

Create a context from local IIO devices (Linux only)

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#gaf31acec2d0f9f498870cc52a1d49783e)
"""
function iio_create_local_context()
    return @check_null ccall((:iio_create_local_context, libiio),
                             Ptr{iio_context},
                             ())
end

"""
    iio_create_xml_context(xml_file)

Create a context from a XML file.

# Parameters
- `xml_file::String` : Path to the XML file to open

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

**NOTE:** The format of the XML must comply to the one returned by iio_context_get_xml.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga9925a84e596c3003e30b1cdd2b65d029)
"""
function iio_create_xml_context(xml_file::String)
    return @check_null ccall((:iio_create_xml_context, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             xml_file)
end

"""
    iio_create_xml_context_mem(xml, len)

Create a context from a XML data in memory.

# Parameters
- `xml::String` : String with the XML data in memory
- `len::Csize_t` : Length of the XML string in memory

# Returns
- On success, a pointer to an [`iio_context`](@ref)
- On failure, an error is raised

**NOTE:** The format of the XML must comply to the one returned by iio_context_get_xml.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#gabaa848ca554af5723a44b9b7fd0ba6a3)
"""
function iio_create_xml_context_mem(xml::String, len::Csize_t)
    return @check_null ccall((:iio_create_xml_context_mem, libiio),
                             Ptr{iio_context},
                             (Cstring, Csize_t),
                             xml, len)
end

"""
    iio_create_network_context(host)

Create a context from the network.

# Parameters
- `host::String` : Hostname, IPv4 or IPv6 address where the IIO Daemon is running

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga8adf2ef4d2b62aa34201469cd7049617)
"""
function iio_create_network_context(host::String)
    return @check_null ccall((:iio_create_network_context, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             host)
end

"""
    iio_create_context_from_uri(uri)

Create a context from an URI description.

# Parameters
- `uri::String` : An URI describing the context location

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

**NOTE:** The following URIs are supported based on compile time backend support:

- Local backend, "local:"
  Does not have an address part. For example "local:"
- XML backend, "xml:"
  Requires a path to the XML file for the address part. For example "xml:/home/user/file.xml"
- Network backend, "ip:"
  Requires a hostname, IPv4, or IPv6 to connect to a specific running IIO Daemon or
  no address part for automatic discovery when library is compiled with ZeroConf support.
  For example "ip:192.168.2.1", or "ip:localhost", or "ip:" or "ip:plutosdr.local".
  To support alternative port numbers the standard ip:host:port format is used.
  A special format is required as defined in RFC2732 for IPv6 literal hostnames,
  (adding '[]' around the host) to use a ip:[x:x:x:x:x:x:x:x]:port format.
  Valid examples would be:
    - ip: Any host on default port
    - ip::40000 Any host on port 40000
    - ip:analog.local Default port
    - ip:brain.local:40000 Port 40000
    - ip:192.168.1.119 Default Port
    - ip:192.168.1.119:40000 Port 40000
    - ip:2601:190:400:da:47b3:55ab:3914:bff1 Default Port
    - ip:[2601:190:400:da:9a90:96ff:feb5:acaa]:40000 Port 40000
- USB backend, "usb:"
  When more than one usb device is attached, requires bus, address, and interface parts
  separated with a dot. For example "usb:3.32.5". Where there is only one USB device attached,
  the shorthand "usb:" can be used.
- Serial backend, "serial:"
  Requires:
    - a port (/dev/ttyUSB0),
    - baud_rate (default 115200)
    - serial port configuration
        - data bits (5 6 7 8 9)
        - parity ('n' none, 'o' odd, 'e' even, 'm' mark, 's' space)
        - stop bits (1 2)
        - flow control ('\0' none, 'x' Xon Xoff, 'r' RTSCTS, 'd' DTRDSR)
  For example "serial:/dev/ttyUSB0,115200" or "serial:/dev/ttyUSB0,115200,8n1"

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#gafdcee40508700fa395370b6c636e16fe)
"""
function iio_create_context_from_uri(uri::String)
    return @check_null ccall((:iio_create_context_from_uri, libiio),
                             Ptr{iio_context},
                             (Cstring,),
                             uri)
end

"""
    iio_context_clone(ctx)

Duplicate a pre-existing IIO context.

# Parameters
- `ctx::Ptr{iio_context}` : A pointer to an [`iio_context`](@ref) structure

# Returns
- On success, a pointer to an [`iio_context`](@ref) structure
- On failure, an error is raised

**NOTE:** This function is not supported on 'usb:' contexts, since libusb can only claim the
          interface once. "Function not implemented" is the expected errno. Any context
          which is cloned, must be destroyed via calling [`iio_context_destroy()`](@ref)

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga1815e7c39b9a69aa11cf948b0433df01)
"""
function iio_context_clone(ctx::Ptr{iio_context})
    return @check_null ccall((:iio_context_clone, libiio),
                             Ptr{iio_context},
                             (Ptr{iio_context},),
                             ctx)
end

"""
    iio_context_destroy(ctx)

Destroy the given context.

# Parameters
- `ctx::Ptr{iio_context}` : A pointer to an [`iio_context`](@ref) structure

**NOTE:** After that function, the iio_context pointer shall be invalid.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga75de8dae515c539818e52b408830d3ba)
"""
function iio_context_destroy(ctx::Ptr{iio_context})
    return @check_null ccall((:iio_context_destroy, libiio),
                             Cvoid,
                             (Ptr{iio_context},),
                             ctx)
end

"""
    iio_context_get_version(ctx)

Get the version of the backend in use.

# Parameters
- `ctx::Ptr{iio_context}` : A pointer to an [`iio_context`](@ref) structure

# Returns
- On success, A 4-Tuple of (0, major, minor, git_tag) is returned
- On error, a negative errno code is returned

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga342bf90d946e7ed3815372db22c4d3a6)
"""
function iio_context_get_version(ctx::Ptr{iio_context})
    major, minor, git_tag = Ref{Cuint}(0), Ref{Cuint}(0), Vector{Cchar}(undef, 8)

    ret = ccall((:iio_context_get_version, libiio),
                Cint,
                (Ptr{iio_context}, Ref{Cuint}, Ref{Cuint}, Ptr{Cchar}),
                ctx, major, minor, pointer(git_tag))

    return ret, UInt(major[]), UInt(minor[]), unsafe_string(pointer(git_tag))
end

"""
    iio_context_get_xml(ctx)

Obtain a XML representation of the given context.

# Parameters
- `ctx::Ptr{iio_context}` : A pointer to an [`iio_context`](@ref) structure

# Returns
- A `String` containing the XML content.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#ga86554706f17faf41e61e3295dc68a70c)
"""
function iio_context_get_xml(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_xml, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

"""
    iio_context_get_name(ctx)

Get the name of the given context.

# Parameters
- `ctx::Ptr{iio_context}` : A pointer to an [`iio_context`](@ref) structure

# Returns
- A `String` containing the name

**NOTE:** The returned string will be local, xml or network when the context has been
          created with the local, xml and network backends respectively.

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/group__Context.html#gafed8e036873ad6f70c3db92c7136ad31)
"""
function iio_context_get_name(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_name, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

function iio_context_get_description(ctx::Ptr{iio_context})
    return unsafe_string(ccall((:iio_context_get_description, libiio),
                               Cstring,
                               (Ptr{iio_context},),
                               ctx))
end

function iio_context_get_attrs_count(ctx::Ptr{iio_context})
    return ccall((:iio_context_get_attrs_count, libiio),
                 Cuint,
                 (Ptr{iio_context},),
                 ctx)
end

function iio_context_get_attr(ctx::Ptr{iio_context}, index::Cuint)
    name, value = Ref{Cstring}(), Ref{Cstring}()
    ret = ccall((:iio_context_get_attr, libiio),
                Cint,
                (Ptr{iio_context}, Cuint, Ptr{Cstring}, Ptr{Cstring}),
                ctx, index, name, value)

    return (ret == 0) ? (ret, unsafe_string(name[]), unsafe_string(value[])) : (ret, "", "")
end

function iio_context_get_attr_value(ctx::Ptr{iio_context}, name::String)
    value = ccall((:iio_context_get_attr_value, libiio),
                  Cstring,
                  (Ptr{iio_context}, Cstring),
                  ctx, name)

    return value != C_NULL ? unsafe_string(value) : ""
end

function iio_context_get_devices_count(ctx::Ptr{iio_context})
    return ccall((:iio_context_get_devices_count, libiio),
                 Cuint,
                 (Ptr{iio_context},),
                 ctx)
end

function iio_context_get_device(ctx::Ptr{iio_context}, index::Cuint)
    return @check_null ccall((:iio_context_get_device, libiio),
                             Ptr{iio_device},
                             (Ptr{iio_context}, Cuint),
                             ctx, index)
end

function iio_context_find_device(ctx::Ptr{iio_context}, name::String)
    return @check_null ccall((:iio_context_find_device, libiio),
                             Ptr{iio_device},
                             (Ptr{iio_context}, Cstring),
                             ctx, name)
end

function iio_context_set_timeout(ctx::Ptr{iio_context}, timeout_ms::Cuint)
    return ccall((:iio_context_set_timeout, libiio),
                 Cint,
                 (Ptr{iio_context}, Cuint),
                 ctx, timeout_ms)
end
