function process(::Type{StatPlotsRecipe}, a::Analysis)
    args = Tuple(Iterators.filter(i -> i !== nothing, (a.x, a.y, a.z)))
    t = a.data.table
    grp_cols = splitby(a)
    cols = select(t, All(args, grp_cols)) |> dropmissing
    nbins = a.smoother === nothing ? () : [:nbins => 120-a.smoother/2]
    a.plot(columns(cols, args)...;
        nbins...,
        group = columns(cols, grp_cols),
        get_style(a.data)...,
        a.plot_kwargs...)
end
