layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(cs::AbstractArray{<:ChecklistColumn}) = hbox(layout.(cs)...)
