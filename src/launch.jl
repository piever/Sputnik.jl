launch() = _display(loadbutton())


launch(t::AbstractString) = launch(loadtable(t))

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
    dom"div"(vbox(loadbutton(), hbox(layout(plot_options), hskip(20px), command), layout(checklists), layout(predicates), plt), smoother) |> _display
end

# To do: make it work not only in Juno but in every other environment

_display(t) = display(t)
