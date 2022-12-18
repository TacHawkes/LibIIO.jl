#=
Empty structs for C pointers
=#
mutable struct iio_scan_context
    function iio_scan_context()
        ctx = new()
        finalizer(x->iio_scan_context_destroy(pointer(x)), ctx)
    end
end
mutable struct iio_scan_block end
mutable struct iio_context_info end
mutable struct iio_context end
mutable struct iio_device end
mutable struct iio_channel end
mutable struct iio_buffer end

"""

See [libiio](https://analogdevicesinc.github.io/libiio/master/libiio/structiio__data__format.html)
"""
mutable struct iio_data_format
    length::Cuint
    bits::Cuint
    shift::Cuint
    is_signed::Cuchar
    is_fully_defined::Cuchar
    is_be::Cuchar
    with_scale::Cuchar
    scale::Cdouble
    repeat::Cuint
end

"""

(https://analogdevicesinc.github.io/libiio/master/libiio/iio_8h.html#a944ad22f426e09cdbb493081a05472e5)
"""
@enum iio_modifier begin
    IIO_NO_MOD
    IIO_MOD_X
    IIO_MOD_Y
    IIO_MOD_Z
    IIO_MOD_X_AND_Y
    IIO_MOD_X_AND_Z
    IIO_MOD_Y_AND_Z
    IIO_MOD_X_AND_Y_AND_Z
    IIO_MOD_X_OR_Y
    IIO_MOD_X_OR_Z
    IIO_MOD_Y_OR_Z
    IIO_MOD_X_OR_Y_OR_Z
    IIO_MOD_LIGHT_BOTH
    IIO_MOD_LIGHT_IR
    IIO_MOD_ROOT_SUM_SQUARED_X_Y
    IIO_MOD_SUM_SQUARED_X_Y_Z
    IIO_MOD_LIGHT_CLEAR
    IIO_MOD_LIGHT_RED
    IIO_MOD_LIGHT_GREEN
    IIO_MOD_LIGHT_BLUE
    IIO_MOD_QUATERNION
    IIO_MOD_TEMP_AMBIENT
    IIO_MOD_TEMP_OBJECT
    IIO_MOD_NORTH_MAGN
    IIO_MOD_NORTH_TRUE
    IIO_MOD_NORTH_MAGN_TILT_COMP
    IIO_MOD_NORTH_TRUE_TILT_COMP
    IIO_MOD_RUNNING
    IIO_MOD_JOGGING
    IIO_MOD_WALKING
    IIO_MOD_STILL
    IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z
    IIO_MOD_I
    IIO_MOD_Q
    IIO_MOD_CO2
    IIO_MOD_VOC
    IIO_MOD_LIGHT_UV
    IIO_MOD_LIGHT_DUV
    IIO_MOD_PM1
    IIO_MOD_PM2P5
    IIO_MOD_PM4
    IIO_MOD_PM10
    IIO_MOD_ETHANOL
    IIO_MOD_H2
    IIO_MOD_O2
    IIO_MOD_LINEAR_X
    IIO_MOD_LINEAR_Y
    IIO_MOD_LINEAR_Z
    IIO_MOD_PITCH
    IIO_MOD_YAW
    IIO_MOD_ROLL
end

@enum iio_chan_type begin
    IIO_VOLTAGE
    IIO_CURRENT
    IIO_POWER
    IIO_ACCEL
    IIO_ANGL_VEL
    IIO_MAGN
    IIO_LIGHT
    IIO_INTENSITY
    IIO_PROXIMITY
    IIO_TEMP
    IIO_INCLI
    IIO_ROT
    IIO_ANGL
    IIO_TIMESTAMP
    IIO_CAPACITANCE
    IIO_ALTVOLTAGE
    IIO_CCT
    IIO_PRESSURE
    IIO_HUMIDITYRELATIVE
    IIO_ACTIVITY
    IIO_STEPS
    IIO_ENERGY
    IIO_DISTANCE
    IIO_VELOCITY
    IIO_CONCENTRATION
    IIO_RESISTANCE
    IIO_PH
    IIO_UVINDEX
    IIO_ELECTRICALCONDUCTIVITY
    IIO_COUNT
    IIO_INDEX
    IIO_GRAVITY
    IIO_POSITIONRELATIVE
    IIO_PHASE
    IIO_MASSCONCENTRATION
    IIO_CHAN_TYPE_UNKNOWN = typemax(Cint)
end

function check_null(input)
    if input == C_NULL
        @static if Sys.iswindows()
            err = Libc.GetLastError()
            error(Libc.FormatMessage(err))
        else
            err = Libc.errno()
            error(Libc.strerror(err))
        end
    end

    return input
end

macro check_null(ex)
    quote
        local val = $(esc(ex))
        check_null(val)
    end
end
