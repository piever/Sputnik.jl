IndexedTables.table(s::SelectedData) = reindex(s.table, s.splitby)
IndexedTables.table(s::Data2Select) = table(SelectedData(s))
IndexedTables.table(a::Analysis) = table(a.data)

process(::Type{<:NextTable}, a::Analysis) = table(a)
