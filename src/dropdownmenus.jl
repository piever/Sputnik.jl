struct DropdownItem
    name
    items
end

DropdownItem(v; label = "select") = DropdownItem(label, dropdown(v, label = label))

function dropdownrow(t::NextTable)
    n = string.(colnames(t))
    x = DropdownItem(n, label = "x")
    y = DropdownItem(vcat(["hazard", "density", "cumulative"], n), label = "y")
    plotlist = [
        "plot",
        "scatter",
        "groupedbar",
        "boxplot",
        "violin",
        "marginalhist"
    ]
    plot_type = DropdownItem(plotlist, label = "plot")
    across = DropdownItem(vcat(["none", "bootstrap", "across"], "across " .* n), label = "across")
    [x, y, plot_type, across]
end

selecteditems(c::DropdownItem) = observe(c.items).val
selecteditems(c::AbstractArray{<:DropdownItem}) = selecteditems.(c)
