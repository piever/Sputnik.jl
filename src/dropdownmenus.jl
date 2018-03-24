const plot_dict = Dict(
    "lineplot" => plot,
    "scatter" => scatter,
    "bar" => groupedbar,
    "boxplot" => boxplot,
    "violin" => violin,
    "marginalhist" => marginalhist
)


struct DropdownItem
    name
    items
    transform
end

DropdownItem(v, transform = Symbol; label = "select") = DropdownItem(label, dropdown(v, label = label), transform)

function dropdownrow(t::NextTable)
    n = string.(colnames(t))
    x = DropdownItem(n, label = "x")
    y = DropdownItem(vcat(["hazard", "density", "cumulative"], n), label = "y")
    plotlist = collect(keys(plot_dict))
    plot_type = DropdownItem(plotlist, x -> plot_dict[x], label = "plot")
    across = DropdownItem(vcat(["none", "bootstrap", "across"], "across " .* n),
                          t -> t == "none" ? nothing : Symbol(t),
                          label = "across")
    [x, y, plot_type, across]
end

selecteditems(c::DropdownItem) = observe(c.items).val |> c.transform
selecteditems(c::AbstractArray{<:DropdownItem}) = selecteditems.(c)
