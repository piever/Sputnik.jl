layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(cs::AbstractArray{<:ChecklistColumn}) = hbox(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(hskip(20px), getfield.(cs, :items)))

default_plot() = scatter(rand(100))

function launch(t::NextTable)
    plot_options = dropdownrow(t)
    data_columns = checklistcolumns(t)
    plot_command = button("Plot")
    spreadsheet_command = button("Spreadsheet")
    command = vbox(plot_command, spreadsheet_command)
    plt = Observable{Any}(default_plot())
    smoother = slider(1:100, label = "smoothing")
    on(x -> plt[] = build_spreadsheet(t, data_columns), observe(spreadsheet_command))
    onany((x, y) -> plt[] = build_plot(t, plot_options, data_columns, y), observe(plot_command), observe(smoother))
    dom"div"(vbox(hbox(layout(plot_options), hskip(20px), command), layout(data_columns), plt), smoother)
end
