abstract type AbstractSelector; end

struct SelectValues{T}<:AbstractSelector
    name::Symbol
    values::Vector{T}
    filter::Bool
end

SelectValues(name, values) = SelectValues(name, values, false)

_select_el(el, s::SelectValues) = el in s.values

struct SelectWithin{T}<:AbstractSelector
    name::Symbol
    min::T
    max::T
    filter::Bool
end

SelectWithin(name, min, max) = SelectWithin(name, min, max, false)

_select_el(el, s::SelectWithin) = s.min <= el <= s.max

struct SelectPredicate{T}<:AbstractSelector
    name::Symbol
    f::T
    filter::Bool
end

SelectPredicate(name, f) = SelectPredicate(name, f, false)

_select_el(el, s::SelectPredicate) = s.f(el)

function Base.convert(::Type{NamedTuple}, args::AbstractSelector...)
    s = Tuple(Iterators.filter(t -> t.filter, args))
    IndexedTables.namedtuple((i.name for i in s)...)(s...)
end

_select(t, args...) = _select(t, convert(NamedTuple, args...))

@generated function _select(t, i::T) where {T<:NamedTuple}
    fn = fieldnames(T)
    foldl((x, y) -> Expr(:(&&), x, Expr(:call, :_select_el, Expr(:., :t, Expr(:quote, y)), Expr(:., :i, Expr(:quote, y)))), :(true), fn)
end

selectdata(t, args...) = selectdata(t, convert(NamedTuple, args...))
selectdata(t, i::NamedTuple) = filter(x -> _select(x, i), t)

struct Data2Select{T<:AbstractIndexedTable, N1, N2}
    table::T
    discrete::NTuple{N1, SelectValues}
    continuous::NTuple{N2, SelectPredicate}
end

struct SelectedData{T<:AbstractIndexedTable}
    table::T
    categoricalstyle::OrderedDict{Symbol, Symbol}
    continuousstyle::OrderedDict{Symbol, Symbol}
end

SelectedData(d2s::Data2Select) =
    SelectedData(selectdata(d2s.table, d2s.discrete..., d2s.continuous...), OrderedDict{Symbol, Symbol}(), OrderedDict{Symbol, Symbol}())

splitby(sd::SelectedData) = Tuple(keys(sd.categoricalstyle))
orderby(sd::SelectedData) = tuple(keys(sd.categoricalstyle)..., keys(sd.continuousstyle)...)
# Base.:(==)(a::SelectedData, b::SelectedData) = (a.table == b.table) && (a.splitby == b.splitby)
