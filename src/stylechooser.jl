mutable struct StyleChooser<:AbstractColumn
    name::Symbol
    widget
    style::DropdownItem
    categorical::Bool
end

function StyleChooser(name::Symbol, options::AbstractArray = styles; categorical=true, vskip=0em, kwargs...)
    dropdown = DropdownItem(string.(options), label = nothing)
    ui = togglecontent(layout(dropdown); label=string(name), vskip=vskip, kwargs...)
    StyleChooser(name, ui, dropdown, categorical)
end

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

isselected(t::StyleChooser) = observe(t.widget)[]
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
