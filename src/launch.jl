set_ui!(ui) = (setupfolders(); ui[] = hbox(loadfrommemory(ui), hskip(20px), loadbutton(ui)))

set_ui!(ui, t::AbstractString) = set_ui!(ui, loadtable(t))

function set_ui!(ui, t::NextTable)
    setupfolders()
    d_obs = Observable{Any}(loadfrommemory(ui))
    s = loadbutton(ui)
    plot_options = dropdownrow(t)
    checklists, predicates = selectioncolumns(t)
    plot_command = button("Plot")
    spreadsheet_command = button("Spreadsheet")
    save_plot_button = PlotSaver()
    save_table_button = TableSaver()
    plot_buttons = hbox(plot_command, hskip(20px), save_plot_button.button, save_plot_button.name)
    table_buttons = hbox(spreadsheet_command,
                         hskip(20px),
                         save_table_button.button,
                         save_table_button.name,
                         hskip(20px),
                         save_table_button.checkbox)
    plt = Observable{Any}(default_plot())
    plt_kwargs = textbox("Insert plot attributes")
    smoother = slider(1:100, label = "smoothing")
    on(x -> plt[] = build_spreadsheet(t, checklists, predicates), observe(spreadsheet_command))
    on(x -> savefig(plt[], filename(save_plot_button)), observe(save_plot_button))
    onany((x, y) -> plt[] = build_plot(t, plot_options, checklists, predicates, plt_kwargs, y), observe(plot_command), observe(smoother))
    on(x -> (_save(t, checklists, predicates, filename(save_table_button), isselected(save_table_button)); d_obs[] = loadfrommemory(ui)),
        observe(save_table_button))

    selection = dom"div"(
        layout(checklists),
        vskip(20px),
        layout(predicates),
    )
    plot_area = dom"div"(
        table_buttons,
        vskip(20px),
        plt,
        plt_kwargs,
        smoother
    )

    menu_buttons = togglebuttons(["Load", "Filter"])
    menu_dict = Dict(
        "Load" => dom"div"(pad(1em, d_obs), pad(1em, s)),
        "Filter" => pad(1em, selection)
    )

    ui[] = dom"div.columns"(
        dom"div.column.col-5.bg-secondary[style=height:100%;overflow-y:scroll;overflow-x:hidden]"(
            pad(1em, menu_buttons),
            map(t -> get(menu_dict, t, dom"div"()), observe(menu_buttons))
        ),
        dom"div.column.col-7[style=height:100%;overflow-y:scroll;overflow-x:hidden]"(
            layout(plot_options),
            plot_buttons,
            plot_area),
    )
end

function get_ui(args...; kwargs...)
    ui = Observable{Any}("")
    set_ui!(ui, args...; kwargs...)
    ui
end

# To do: make it work not only in Juno but in every other environment

#_display(t) = display(t)
function launch(args...; env = :blink, page = "/", kwargs...)
    ui = get_ui(args...; kwargs...)
    _display(dom"div"(ui), env; page = page)
end

function _display(t, env; page = "/")
    if env == :blink
        w = Window()
        body!(w, t)
        w
    elseif env == :juno
        display(t)
    elseif env == :mux
        webio_serve(WebIO.page(page, req -> t))
    else
        error("Only blink, juno and mux supported so far")
    end
end
