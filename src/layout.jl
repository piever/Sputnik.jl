layout(c::ChecklistColumn) = dom"div.column"(c.button, mask(["true"], [dom"div"(getfield.(c.items, :button)...)], key = observe(c.button)))
layout(c::PredicateColumn) = dom"div.column"(c.button, mask(["true"], [c.predicate], key = observe(c.button)))
layout(cs::AbstractArray{<:AbstractColumn}) = Node(:div, className = "column")(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(getfield.(cs, :items), hskip(20px)))

#layout(p::PlotSaver) = hbox(p.button, p.name)
#layout(p::TableSaver) = hbox(p.button, vbox(p.checkbox, p.name))

default_plot() = scatter(rand(100))
