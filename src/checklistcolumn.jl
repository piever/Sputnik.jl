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
    ChecklistColumn(name, togglebuttons([string(name)], multiselect = true), ChecklistItem.(values))

selecteditems(col::ChecklistColumn) = [i.value for i in col.items if isselected(i)]

isselected(col::ChecklistColumn) = !isempty(observe(col.button).val)

name(col::ChecklistColumn) = col.name

# mutable struct PredicateColumn
#     name
#     button
#     predicate
# end
#
# function parsepredicate(s)
#     expr = parse("_ -> " * s)
#     sym = gensym()
#     flag = Ref(false)
#     expr = MacroTools.postwalk(x -> x == :(_) ? (flag[] = true; sym) : x, parse(s))
#     flag[] ? eval(Expr(:->, sym, expr)) : eval(expr)
# end
#
# update_function!(p::SelectPredicate, s) =
#     try
#         p.predicate = parsepredicate(s)
#     end
#
#
# function Sputnik.SelectPredicate(p::PredicateColumn)


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

Sputnik.SelectValues(c::ChecklistColumn) =
    SelectValues(c.name, selecteditems(c), isselected(c))

Sputnik.Data2Select(t, d::AbstractArray{<:ChecklistColumn}) =
    Data2Select(t, Tuple(SelectValues.(d)), ())
