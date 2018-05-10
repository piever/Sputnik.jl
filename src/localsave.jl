setupfolders() =
    mkpath.([tablefolder, plotfolder])

mutable struct PlotSaver
    name
    button
end

PlotSaver(btn = "Save figure as"; label = "name") =
    PlotSaver(textbox(label), button(btn))

InteractNative.observe(p::PlotSaver) = observe(p.button)

name(p::PlotSaver) = observe(p.name).val
filename(p::PlotSaver) = joinpath(plotfolder, name(p))

mutable struct TableSaver
    name
    button
    checkbox
end

TableSaver(btn = "Save table as"; label = "name", checkbox = "select data") =
    TableSaver(textbox(label), button(btn), InteractNative.input(true, typ="checkbox", label = checkbox))

InteractNative.observe(p::TableSaver) = observe(p.button)

name(p::TableSaver) = observe(p.name).val
filename(p::TableSaver) = joinpath(tablefolder, name(p))
isselected(t::TableSaver) = observe(t.checkbox).val

function _save(t, checklists, predicates, fn, sel)
    t1 = sel ? build_table(t, checklists, predicates) : t
    JuliaDB.save(t1, fn)
end
