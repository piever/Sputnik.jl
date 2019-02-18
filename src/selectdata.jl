struct SelectedData{T<:AbstractIndexedTable}
    table::T
    categoricalstyle::OrderedDict{Symbol, Symbol}
    continuousstyle::OrderedDict{Symbol, Symbol}
end

SelectedData(t::AbstractIndexedTable) = SelectedData(t::AbstractIndexedTable, OrderedDict{Symbol, Symbol}(), OrderedDict{Symbol, Symbol}())

splitby(sd::SelectedData) = Tuple(keys(sd.categoricalstyle))
orderby(sd::SelectedData) = tuple(keys(sd.categoricalstyle)..., keys(sd.continuousstyle)...)
