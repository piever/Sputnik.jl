layout(c::ChecklistColumn) = dom"div.column"(c.button, getfield.(c.items, :button)...)
layout(c::PredicateColumn) = dom"div.column"(c.button, c.predicate)
layout(cs::AbstractArray{<:AbstractColumn}) = Node(:div, className = "columns is-multiline")(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(getfield.(cs, :items), hskip(20px)))

#layout(p::PlotSaver) = hbox(p.button, p.name)
#layout(p::TableSaver) = hbox(p.button, vbox(p.checkbox, p.name))

default_plot() = scatter(rand(100))
