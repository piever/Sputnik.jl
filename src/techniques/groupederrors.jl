function compute_error(s, cpt_err)
    if cpt_err[1] == :across
        GroupedErrors._across(s, cpt_err[2])
    elseif cpt_err[1] == :bootstrap
        GroupedErrors._bootstrap(s, cpt_err[2])
    else
        error("Compute error $cpt_err not supported")
    end
end

compute_error(s, ::Nothing) = s

function smoothing_kwargs(a::Analysis)
    iscontinuous(a) || return []
    a.y in colnames(a.data.table) && return [(:span, (a.smoother+1.0)/100)]
    a.y in [:density, :hazard] && return [(:bandwidth, (a.smoother+1.0)*std(column(a.data.table, a.x))/200)]
    return []
end

ispointbypoint(a::Analysis) =
    a.axis_type == :pointbypoint || (a.axis_type == :auto) && (a.y in colnames(a.data.table))

isdiscrete(a::Analysis) =
    a.axis_type == :discrete || (a.axis_type == :auto) && !(eltype(column(a.data.table, a.x))<:Real)

isbinned(a) = a.axis_type == :binned

iscontinuous(a) = !ispointbypoint(a) && !isdiscrete(a) && !isbinned(a)

function process(::Type{GroupedError}, a::Analysis)
    s = GroupedErrors.ColumnSelector(a.data.table)
    s = GroupedErrors._splitby(s, Symbol[splitby(a)...])
    s = compute_error(s, a.compute_error)
    if !ispointbypoint(a)
        maybe_nbins = isbinned(a) ? (round(Int64, (120-a.smoother)/2),) : ()
        s = GroupedErrors._x(s, a.x, a.axis_type, maybe_nbins...)
        y = a.y in colnames(a.data.table) ? (:locreg, a.y) : (a.y,)
        s = GroupedErrors._y(s, y...; smoothing_kwargs(a)...)
    else
        s = GroupedErrors._x(s, a.x, a.xfunc)
        s = GroupedErrors._y(s, a.y, a.yfunc)
    end
    plot_closure(args...; kwargs...) = a.plot(args...; kwargs..., get_style(a.data)..., a.plot_kwargs...)
    (a.plot == plot) ? @plot(s, plot_closure(), :ribbon) : @plot(s, plot_closure())
end
