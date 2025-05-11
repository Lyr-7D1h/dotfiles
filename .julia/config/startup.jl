function mixed_fraction(x::Real)
    int_part = floor(Int, x)
    frac_part = x - int_part
    if frac_part == 0
        return string(int_part)
    else
        r = rationalize(frac_part)
        return replace(string(int_part, " ", r), "//" => "/")
    end
end

