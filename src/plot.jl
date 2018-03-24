function build_plot(t, plot_options, data_columns, smoother)
    s = SelectedData(Data2Select(t, data_columns))
    x, y, plt, axis_type, across = selecteditems(plot_options)
    a = Analysis(data=s,
                 x=x,
                 y=y,
                 xfunc=mean,
                 yfunc=mean,
                 plot=plt,
                 compute_error=across,
                 axis_type=axis_type,
                 smoother = observe(smoother)[])
    process(a)
end
