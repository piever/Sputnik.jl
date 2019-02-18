IndexedTables.table(s::SelectedData) = isempty(orderby(s)) ? s.table : reindex(s.table, orderby(s))
IndexedTables.table(a::Analysis) = table(a.data)

process(::Type{<:IndexedTable}, a::Analysis) = table(a)
