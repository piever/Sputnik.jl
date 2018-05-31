layout(c::AbstractColumn) = dom"div.column"(c.widget)
layout(cs::AbstractArray{<:AbstractColumn}) = Node(:div, className = "column")(layout.(cs)...)

layout(c::DropdownItem) = c.items
layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(layout.(cs), hskip(20px)))

#layout(p::PlotSaver) = hbox(p.button, p.name)
#layout(p::TableSaver) = hbox(p.button, vbox(p.checkbox, p.name))

default_plot() = scatter(rand(100))
