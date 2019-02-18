default_plot() = scatter(rand(100))

function build_plot(t, plot_options, style, plot_kwargs, smoother)
    s = SelectedData(t)
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

build_spreadsheet(filtered_data, style) = TableWidgets.head(build_table(filtered_data, style), 1000)

function build_table(t, style)
    s = SelectedData(t)
    update!(s, style)
    table(s)
end

extract_kwargs(; kwargs...) = kwargs
extract_kwargs(plot_kwargs::AbstractString) = eval(Meta.parse("extract_kwargs($plot_kwargs)"))
