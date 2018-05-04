launch() = (setupfolders(); _display(loadbutton()))

launch(t::AbstractString) = launch(loadtable(t))

function launch(t::NextTable)
    setupfolders()
    plot_options = dropdownrow(t)
    checklists, predicates = selectioncolumns(t)
    plot_command = button("Plot")
    spreadsheet_command = button("Spreadsheet")
    save_plot_button = PlotSaver()
    save_table_button = TableSaver()
    plot_buttons = hbox(plot_command, save_plot_button.button, save_plot_button.name)
    table_buttons = hbox(spreadsheet_command,
                         save_table_button.button,
                         save_table_button.checkbox,
                         save_table_button.name)
    plt = Observable{Any}(default_plot())
    smoother = slider(1:100, label = "smoothing")
    on(x -> plt[] = build_spreadsheet(t, checklists, predicates), observe(spreadsheet_command))
    on(x -> savefig(plt[], filename(save_plot_button)), observe(save_plot_button))
    onany((x, y) -> plt[] = build_plot(t, plot_options, checklists, predicates, y), observe(plot_command), observe(smoother))
    on(x -> _save(t, checklists, predicates, filename(save_table_button), isselected(save_table_button)), observe(save_table_button))
    dom"div"(vbox(
        loadbutton(),
        hbox(layout(plot_options), hskip(20px), plot_buttons),
        layout(checklists),
        layout(predicates),
        table_buttons,
        plt),
        smoother) |> _display
end

# To do: make it work not only in Juno but in every other environment

_display(t) = display(t)
