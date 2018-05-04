mutable struct ChecklistItem{T}
    value::T
    button
end

ChecklistItem(value) = ChecklistItem(value, InteractNext.checkbox(true, label = string(value)))

isselected(item::ChecklistItem) = obs(item.button).val

abstract type AbstractColumn; end

mutable struct ChecklistColumn<:AbstractColumn
    name
    button
    items::Vector{<:ChecklistItem}
end

ChecklistColumn(name, values) =
    ChecklistColumn(name, togglebuttons([string(name)], multiselect = true), ChecklistItem.(values))

selecteditems(col::ChecklistColumn) = [i.value for i in col.items if isselected(i)]

isselected(col::ChecklistColumn) = !isempty(observe(col.button).val)

name(col::ChecklistColumn) = col.name

Sputnik.SelectValues(c::ChecklistColumn) =
    SelectValues(c.name, selecteditems(c), isselected(c))

# _true(t) = true

mutable struct PredicateColumn<:AbstractColumn
    name
    button
    predicate
    f
    function PredicateColumn(name, button, predicate, f)
        s = new(name, button, predicate, f)
        on(x -> (update_function!(s, x)), observe(s.predicate))
        s
    end
end

PredicateColumn(name) =
    PredicateColumn(name,
                    togglebuttons([string(name)], multiselect = true),
                    InteractNext.textbox("insert condition"),
                    t -> true)

function parsepredicate(s)
    ismatch(r"^(\s)*$$", s) && return :(t -> true)
    expr = parse("_ -> " * s)
    sym = gensym()
    flag = Ref(false)
    expr = MacroTools.postwalk(x -> x == :(_) ? (flag[] = true; sym) : x, parse(s))
    flag[] ? Expr(:->, sym, expr) : expr
end

update_function!(p::PredicateColumn, s) =
    try
        @eval ($p).f = $(parsepredicate(s))
    end

isselected(col::PredicateColumn) = !isempty(observe(col.button).val)

name(col::PredicateColumn) = col.name

Sputnik.SelectPredicate(c::PredicateColumn) = SelectPredicate(c.name, c.f, isselected(c))

function selectioncolumns(t::NextTable; nbox = 5)
    v = ChecklistColumn[]
    w = PredicateColumn[]
    for n in colnames(t)
        u = unique(column(t, n))
        if length(u) < nbox
            push!(v, ChecklistColumn(n, u))
        else
            push!(w, PredicateColumn(n))
        end
    end
    v, w
end

Sputnik.Data2Select(t, d::AbstractArray{<:ChecklistColumn}, s::AbstractArray{<:PredicateColumn} = PredicateColumn[]) =
    Data2Select(t, Tuple(SelectValues.(d)), Tuple(SelectPredicate.(s)))
