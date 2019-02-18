mutable struct StyleChooser
    name::Symbol
    widget
    style
    categorical::Bool
end

layout(c::StyleChooser) = dom"div.column"(c.widget)
layout(cs::AbstractArray{<:StyleChooser}) = node(:div, className = "column")(layout.(cs)...)

layout(c::Widgets.Widget{:dropdown}) = c
layout(cs::AbstractArray{<:Widgets.Widget{:dropdown}}) = hbox(hbox.(layout.(cs), Ref(hskip(20px))))

function StyleChooser(name::Symbol, options::AbstractArray = styles; categorical=true, vskip=0em, kwargs...)
    opts = dropdown(options, label = nothing)
    ui = togglecontent(layout(opts); label=string(name), vskip=vskip, kwargs...)
    StyleChooser(name, ui, opts, categorical)
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
