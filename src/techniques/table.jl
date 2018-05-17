IndexedTables.table(s::SelectedData) = isempty(values(s.splitby)) ? s.table : reindex(s.table, Tuple(values(s.splitby)))
IndexedTables.table(s::Data2Select) = table(SelectedData(s))
IndexedTables.table(a::Analysis) = table(a.data)

process(::Type{<:NextTable}, a::Analysis) = table(a)
