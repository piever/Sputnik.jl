layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(c::PredicateColumn) = vbox(c.button, hbox.(hskip(20px), c.predicate))
layout(cs::AbstractArray{<:AbstractColumn}) = hbox(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(hskip(20px), getfield.(cs, :items)))

default_plot() = scatter(rand(100))

function launch(t::NextTable)
    plot_options = dropdownrow(t)
    checklists, predicates = selectioncolumns(t)
    plot_command = button("Plot")
    spreadsheet_command = button("Spreadsheet")
    command = vbox(plot_command, spreadsheet_command)
    plt = Observable{Any}(default_plot())
    smoother = slider(1:100, label = "smoothing")
    on(x -> plt[] = build_spreadsheet(t, checklists, predicates), observe(spreadsheet_command))
    onany((x, y) -> plt[] = build_plot(t, plot_options, checklists, predicates, y), observe(plot_command), observe(smoother))
    dom"div"(vbox(hbox(layout(plot_options), hskip(20px), command), layout(checklists), layout(predicates), plt), smoother)
end
