layout(c::ChecklistColumn) = dom"div.column"(c.button, mask(["true"], [dom"div"(getfield.(c.items, :button)...)], key = observe(c.button)))
layout(c::PredicateColumn) = dom"div.column"(c.button, mask(["true"], [c.predicate], key = observe(c.button)))
layout(c::StyleChooser) = dom"div.column"(c.button, mask(["true"], [layout(c.style)], key = observe(c.button)))
layout(cs::AbstractArray{<:AbstractColumn}) = Node(:div, className = "column")(layout.(cs)...)

layout(c::DropdownItem) = c.items
layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(layout.(cs), hskip(20px)))

#layout(p::PlotSaver) = hbox(p.button, p.name)
#layout(p::TableSaver) = hbox(p.button, vbox(p.checkbox, p.name))

default_plot() = scatter(rand(100))
