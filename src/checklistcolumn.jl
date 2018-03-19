mutable struct ChecklistItem{T}
    value::T
    button
end

ChecklistItem(value) = ChecklistItem(value, checkbox(true, label = string(value)))

isselected(item::ChecklistItem) = obs(item.button).val

mutable struct ChecklistColumn
    name
    button
    items::Vector{<:ChecklistItem}
end

ChecklistColumn(name, values) =
    ChecklistColumn(name, button(string(name)), ChecklistItem.(values))

selecteditems(col::ChecklistColumn) = [i.value for i in col.items if isselected(i)]

name(col::ChecklistColumn) = col.name

function checklistcolumns(t::NextTable; nbox = 5)
    v = ChecklistColumn[]
    for n in colnames(t)
        u = unique(column(t, n))
        if length(u) < nbox
            push!(v, ChecklistColumn(n, u))
        end
    end
    v
end
