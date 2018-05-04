layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(c::PredicateColumn) = vbox(c.button, hbox.(hskip(20px), c.predicate))
layout(cs::AbstractArray{<:AbstractColumn}) = hbox(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(hskip(20px), getfield.(cs, :items)))

layout(p::PlotSaver) = hbox(p.button, p.name)

default_plot() = scatter(rand(100))
