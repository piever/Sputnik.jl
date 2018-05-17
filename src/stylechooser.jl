mutable struct StyleChooser<:AbstractColumn
    name::Symbol
    button
    style::DropdownItem
end

StyleChooser(name::Symbol, options::AbstractArray = styles) =
    StyleChooser(name, toggle(label = string(name)), DropdownItem(string.(options), label = nothing))

function stylechoosers(t::NextTable, nbox = 5)
    v = StyleChooser[]
    w = StyleChooser[]
    for n in colnames(t)
        u = unique(column(t, n))
        if length(u) < nbox
            push!(v, StyleChooser(n))
        else
            push!(w, StyleChooser(n))
        end
    end
    v, w
end
