"""
Abstract super-type for all Attributes-like types
"""
abstract type Attr end

"""
    read(::Attr)

The current value of this attribute (as string).
"""
read(a::Attr) = error(typeof(attr), " does not support reading")

"""
    write(::Attr, value)

Sets the value of the attribute to the passed value.
"""
write(a::Attr, value) = error(typeof(attr), " does not support writing")

"""
    name(:Attr)
"""
name(a::Attr) = a.name

"""
    filename(:Attr)

The filename in sysfs to which this attribute is bound.
"""
filename(a::Attr) = a.filename
