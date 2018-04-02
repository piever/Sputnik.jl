function compute_error(s, cpt_err)
    if cpt_err[1] == :across
        GroupedErrors._across(s, cpt_err[2])
    elseif cpt_err[1] == :bootstrap
        GroupedErrors._bootstrap(s, cpt_err[2])
    else
        error("Compute error $cpt_err not supported")
    end
end

compute_error(s, ::Void) = s

function smoothing_kwargs(a::Analysis)
    a.axis_type != :continuous && return []
    a.y in colnames(a.data.table) && return [(:span, (a.smoother+1.0)/100)]
    a.y in [:density, :hazard] && return [(:bandwidth, (a.smoother+1.0)*std(column(a.data.table, a.x))/200)]
    return []
end

function process(::Type{GroupedError}, a::Analysis)
    s = GroupedErrors.ColumnSelector(a.data.table)
    s = GroupedErrors._splitby(s, Symbol[a.data.splitby...])
    s = compute_error(s, a.compute_error)
    if a.axis_type != :pointbypoint
        maybe_nbins = a.axis_type == :binned ? (round(Int64, 101-a.smoother),) : ()
        s = GroupedErrors._x(s, a.x, a.axis_type, maybe_nbins...)
        y = a.y in colnames(a.data.table) ? (:locreg, a.y) : (a.y,)
        s = GroupedErrors._y(s, y...; smoothing_kwargs(a)...)
    else
        s = GroupedErrors._x(s, a.x, a.xfunc)
        s = GroupedErrors._y(s, a.y, a.yfunc)
    end
    @plot s a.plot()
end
