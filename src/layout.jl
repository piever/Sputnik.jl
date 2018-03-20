layout(c::ChecklistColumn) = vbox(c.button, hbox.(hskip(20px), getfield.(c.items, :button))...)
layout(cs::AbstractArray{<:ChecklistColumn}) = hbox(layout.(cs)...)

layout(cs::AbstractArray{<:DropdownItem}) = hbox(hbox.(hskip(20px), getfield.(cs, :items)))

function layout(t::NextTable)
    plot_options = dropdownrow(t)
    data_columns = checklistcolumns(t)
    vbox(layout(plot_options), layout(data_columns))
    plot_command = button("Plot")
end
