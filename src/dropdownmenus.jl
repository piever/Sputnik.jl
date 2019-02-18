const plot_dict = OrderedDict(
    "lineplot" => plot,
    "scatter" => scatter,
    "bar" => groupedbar,
    "boxplot" => boxplot,
    "violin" => violin,
    "histogram2d" => histogram2d,
    "marginalhist" => marginalhist,
)

function dropdownrow(t::NextTable)
    ns = collect(colnames(t))
    x = dropdown(ns, label = "x")
    y = dropdown(vcat([:density, :cumulative, :hazard], ns), label = "y")
    plotlist = collect(keys(plot_dict))
    plot_type = dropdown(plot_dict, label = "plot")
    axis_type = dropdown(["auto", "pointbypoint", "discrete", "binned", "continuous"], label = "axis_type")
    across_strs = vcat(["none", "bootstrap", "across"], "across " .* n)
    across_vals = map(across_map, across_strs)
    across = dropdown(OrderedDict(zip(across_strs, across_vals)), label = "compute_error")
    package = dropdown(
        OrderedDict("auto" => nothing, "StatPlots" => StatPlotsRecipe, "GroupedErrors" => GroupedError),
        label = "module"
    )
    [x, y, plot_type, axis_type, across, package]
end

function across_map(s)
    if s=="none"
        nothing
    elseif s == "bootstrap"
        (:bootstrap, 1000)
    elseif s == "across"
        (:across, :all)
    else
        (:across, Symbol(match(r"^across (.*)$", s)[1]))
    end
end

selecteditems(c::AbstractObservable) = c[]
selecteditems(c::AbstractArray) = selecteditems.(c)
