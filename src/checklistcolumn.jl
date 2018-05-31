abstract type AbstractColumn; end

mutable struct ChecklistColumn<:AbstractColumn
    name::Symbol
    widget
    items
end

function ChecklistColumn(name::Symbol, values::Vector; vskip = 0em, kwargs...)
    cb = checkboxes(values, value = values)
    ui = togglecontent(cb, label = string(name); vskip=vskip, kwargs...)
    ChecklistColumn(name, ui, cb)
end

selecteditems(col::ChecklistColumn) = observe(col.items)[]

isselected(col::ChecklistColumn) = observe(col.widget)[]

name(col::ChecklistColumn) = col.name

Sputnik.SelectValues(c::ChecklistColumn) =
    SelectValues(c.name, selecteditems(c), isselected(c))

# _true(t) = true

mutable struct PredicateColumn<:AbstractColumn
    name::Symbol
    widget
    predicate
    f
    function PredicateColumn(name::Symbol, widget, predicate, f)
        s = new(name, widget, predicate, f)
        on(x -> (update_function!(s, x)), observe(s.predicate))
        s
    end
end

function PredicateColumn(name; vskip = 0em, kwargs...)
    tb = textbox("insert condition")
    ui = togglecontent(tb, label = string(name); vskip=vskip, kwargs...)
    PredicateColumn(name, ui, tb, t -> true)
end

function parsepredicate(s)
    ismatch(r"^(\s)*$", s) && return :(t -> true)
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

isselected(col::PredicateColumn) = observe(col.widget)[]

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
