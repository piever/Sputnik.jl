const plot_dict = OrderedDict(
    "lineplot" => plot,
    "scatter" => scatter,
    "bar" => groupedbar,
    "boxplot" => boxplot,
    "violin" => violin,
    "histogram2d" => histogram2d,
    "marginalhist" => marginalhist,
)


struct DropdownItem
    name
    items
    transform
end

DropdownItem(v, transform = Symbol; label = "select") = DropdownItem(label, dropdown(v, v[1], label = label), transform)

function dropdownrow(t::NextTable)
    n = string.(colnames(t))
    x = DropdownItem(n, label = "x")
    y = DropdownItem(vcat(["density", "cumulative", "hazard"], n), label = "y")
    plotlist = collect(keys(plot_dict))
    plot_type = DropdownItem(plotlist, x -> plot_dict[x], label = "plot")
    axis_type = DropdownItem(["auto", "pointbypoint", "discrete", "binned", "continuous"], label = "axis_type")
    across = DropdownItem(vcat(["none", "bootstrap", "across"], "across " .* n),
                          across_map,
                          label = "compute_error")
    [x, y, plot_type, axis_type, across]
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

selecteditems(c::DropdownItem) = observe(c.items).val |> c.transform
selecteditems(c::AbstractArray{<:DropdownItem}) = selecteditems.(c)
