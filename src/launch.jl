set_ui!(ui) = (setupfolders(); ui[] = hbox(loadfrommemory(ui), hskip(20px), loadbutton(ui)))

set_ui!(ui, t::AbstractString) = set_ui!(ui, loadtable(t))

function set_ui!(ui, t::NextTable)
    setupfolders()
    d_obs = Observable{Any}(loadfrommemory(ui))
    s = loadbutton(ui)
    plot_options = dropdownrow(t)
    checklists, predicates = selectioncolumns(t)
    categoricalstyle, continuousstyle = stylechoosers(t)
    style = vcat(categoricalstyle, continuousstyle)
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
    spreadsheet =  Observable{Any}(dom"div"(""))
    plt_kwargs = textbox("Insert plot attributes")
    smoother = slider(1:100, label = "smoothing")
    on(x -> spreadsheet[] = build_spreadsheet(t, checklists, predicates, style), observe(spreadsheet_command))
    on(x -> savefig(plt[], filename(save_plot_button)), observe(save_plot_button))
    onany((x, y) -> plt[] = build_plot(t, plot_options, checklists, predicates, style, plt_kwargs, y), observe(plot_command), observe(smoother))
    on(x -> (_save(t, checklists, predicates, style, filename(save_table_button), isselected(save_table_button)); d_obs[] = loadfrommemory(ui)),
        observe(save_table_button))

    selection = dom"div.columns"(
        layout(checklists),
        layout(predicates),
    )

    left_menu = tabulator(["Load", "Filter", "Style"],
        [
            dom"div"(pad(1em, d_obs), pad(1em, s)),
            pad(1em, selection),
            pad(1em, dom"div.columns"(layout.((categoricalstyle, continuousstyle))...))
        ], value=1)

    plot_view = dom"div"(
        layout(plot_options),
        vskip(2em),
        plot_buttons,
        plt,
        plt_kwargs,
        smoother
    )
    spreadsheet_view = dom"div"(
        table_buttons,
        vskip(20px),
        spreadsheet,
    )

    right_menu = tabulator(["Table", "Graph"], value = 1, [spreadsheet_view, plot_view])

    ui[] = dom"div.columns"(
        dom"div.column.is-two-fifths.has-background-light[style=height:100%;overflow-y:scroll;overflow-x:hidden]"(
            pad(1em, left_menu)
        ),
        dom"div.column[style=height:100%;overflow-y:scroll;overflow-x:hidden]"(
            pad(1em, right_menu)
        )
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
