setupfolders() =
    mkpath.(joinpath.(homedir(), ".sputnik", ["tables", "plots"]))

mutable struct PlotSaver
    name
    button
end

PlotSaver(btn = "Save figure as"; label = "name") =
    PlotSaver(textbox(label), button(btn))

InteractNext.observe(p::PlotSaver) = observe(p.button)

name(p::PlotSaver) = observe(p.name).val
filename(p::PlotSaver) = joinpath(homedir(), ".sputnik", "plots", name(p))
