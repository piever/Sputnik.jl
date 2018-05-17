function build_plot(t, plot_options, checklists, predicates, plot_kwargs, smoother)
    s = SelectedData(Data2Select(t, checklists, predicates))
    x, y, plt, axis_type, across = selecteditems(plot_options)
    a = Analysis(data=s,
                 x=x,
                 y=y,
                 xfunc=mean,
                 yfunc=mean,
                 plot=plt,
                 compute_error=across,
                 axis_type=axis_type,
                 smoother = smoother,
                 plot_kwargs = extract_kwargs(observe(plot_kwargs).val))
    process(a)
end

build_spreadsheet(t, checklists, predicates) = build_table(t, checklists, predicates) |> TableView.showtable

build_table(t, checklists, predicates) = table(Data2Select(t, checklists, predicates))

extract_kwargs(; kwargs...) = kwargs
extract_kwargs(plot_kwargs) = eval(parse("extract_kwargs($plot_kwargs)"))
