layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(cs::AbstractArray{<:ChecklistColumn}) = hbox(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(hskip(20px), getfield.(cs, :items)))

default_plot() = scatter(rand(100))

function launch(t::NextTable)
    plot_options = dropdownrow(t)
    data_columns = checklistcolumns(t)
    plot_command = button("Plot")
    plt = Observable{Any}(default_plot())
    smoother = slider(1:100, label = "smoothing")
    onany((x, y) -> plt[] = build_plot(t, plot_options, data_columns, y), observe(plot_command), observe(smoother))
    dom"div"(vbox(hbox(layout(plot_options), hskip(20px), plot_command), layout(data_columns), plt), smoother)
end
