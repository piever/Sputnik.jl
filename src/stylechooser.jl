mutable struct StyleChooser<:AbstractColumn
    name::Symbol
    button
    style::DropdownItem
    categorical::Bool
end

StyleChooser(name::Symbol, options::AbstractArray = styles; categorical = true) =
    StyleChooser(name, toggle(label = string(name)), DropdownItem(string.(options), label = nothing), categorical)

function stylechoosers(t::NextTable, nbox = 5)
    v = StyleChooser[]
    w = StyleChooser[]
    for n in colnames(t)
        u = unique(column(t, n))
        if length(u) < nbox
            push!(v, StyleChooser(n))
        else
            push!(w, StyleChooser(n, categorical = false))
        end
    end
    v, w
end

isselected(t::StyleChooser) = observe(t.button).val
selecteditems(t::StyleChooser) = selecteditems(t.style)

function update!(s::SelectedData, cs::AbstractArray{<:StyleChooser})
    empty!(s.categoricalstyle)
    empty!(s.continuousstyle)
    for c in cs
        if isselected(c)
            c.categorical ? (s.categoricalstyle[c.name] = selecteditems(c)) :
                            (s.continuousstyle[c.name] = selecteditems(c))
        end
    end
end
