struct SelectValues{T}
    name::Symbol
    values::Vector{T}
    split::Bool
    filter::Bool
end

SelectValues(name, values, split = false) = SelectValues(name, values, split, true)

struct SelectPredicate{T}
    name::Symbol
    f::T
    split::Bool
    filter::Bool
end

SelectPredicate(name, f, split = false) = SelectPredicate(name, f, split, true)

struct Data2Select{T<:AbstractIndexedTable, N1, N2}
    table::T
    discrete::NTuple{N1, SelectValues}
    continuous::NTuple{N2, SelectPredicate}
end

struct SelectedData{T<:AbstractIndexedTable, N}
    table::T
    splitby::NTuple{N, Symbol}
end

SelectedData(d2s::Data2Select) =
    SelectedData(selectdata(d2s.table, d2s.discrete, d2s.continuous), Tuple(i.name for i in d2s.discrete if i.split))

Base.:(==)(a::SelectedData, b::SelectedData) = (a.table == b.table) && (a.splitby == b.splitby)

function selectdata(df, discrete, continuous)
    f = function(i)
        all(getfield(i, s.name) in s.values for s in discrete if s.filter) &&
        all(s.f(getfield(i, s.name)) for s in continuous if s.filter)
    end
    filter(f, df)
end
