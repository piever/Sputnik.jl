function build_plot(t, plot_options, data_columns)
    s = SelectedData(Data2Select(t, data_columns))
    x, y, plt, across = selecteditems(plot_options)
    a = Analysis(data=s, x=x, y=y, plot=plt, compute_error=across)
    process(a)
end
