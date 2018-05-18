IndexedTables.table(s::SelectedData) = isempty(splitby(s)) ? s.table : reindex(s.table, splitby(s))
IndexedTables.table(s::Data2Select) = table(SelectedData(s))
IndexedTables.table(a::Analysis) = table(a.data)

process(::Type{<:NextTable}, a::Analysis) = table(a)
