function build_plot(t, plot_options, checklists, predicates, style, plot_kwargs, smoother)
    s = SelectedData(Data2Select(t, checklists, predicates))
    update!(s, style)
    x, y, plt, axis_type, across, package = selecteditems(plot_options)
    a = Analysis(data=s,
                 x=x,
                 y=y,
                 xfunc=mean,
                 yfunc=mean,
                 plot=plt,
                 compute_error=across,
                 axis_type=axis_type,
                 smoother = smoother,
                 package = package,
                 plot_kwargs = extract_kwargs(observe(plot_kwargs).val))
    process(a)
end

build_spreadsheet(t, checklists, predicates, style) = build_table(t, checklists, predicates, style) |> TableView.showtable

function build_table(t, checklists, predicates, style)
    s =  SelectedData(Data2Select(t, checklists, predicates))
    update!(s, style)
    table(s)
end

extract_kwargs(; kwargs...) = kwargs
extract_kwargs(plot_kwargs) = eval(parse("extract_kwargs($plot_kwargs)"))
