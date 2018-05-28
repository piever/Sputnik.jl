layout(c::ChecklistColumn) = dom"div.column"(c.button, _mask(observe(c.button), ["true"], [dom"div"(getfield.(c.items, :button)...)]))
layout(c::PredicateColumn) = dom"div.column"(c.button, _mask(observe(c.button), ["true"], [c.predicate]))
layout(c::StyleChooser) = dom"div.column"(c.button, _mask(observe(c.button), ["true"], [layout(c.style)]))
layout(cs::AbstractArray{<:AbstractColumn}) = Node(:div, className = "column")(layout.(cs)...)

layout(c::DropdownItem) = c.items
layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(layout.(cs), hskip(20px)))

#layout(p::PlotSaver) = hbox(p.button, p.name)
#layout(p::TableSaver) = hbox(p.button, vbox(p.checkbox, p.name))

default_plot() = scatter(rand(100))
