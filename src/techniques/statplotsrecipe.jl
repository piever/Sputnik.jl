function process(::Type{StatPlotsRecipe}, a::Analysis)
    args = Tuple(Iterators.filter(i -> i !== nothing, (a.x, a.y, a.z)))
    t = a.data.table
    grp_cols = splitby(a)
    cols = select(t, All(args, grp_cols)) |> dropna
    a.plot(columns(cols, args)...;
        nbins = round(Int64, (120-a.smoother)/2),
        group = columns(cols, grp_cols),
        get_style(a.data)...,
        a.plot_kwargs...)
end
