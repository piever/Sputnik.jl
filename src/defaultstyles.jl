# Default styles for Grammar of Graphics like interface
import ColorBrewer

const palette_dict = OrderedDict(
    :color => ColorBrewer.palette("Set1", 8),
    :markershape => [:diamond, :circle, :triangle, :star5],
    :linestyle => [:solid, :dash, :dot, :dashdot],
    :linewidth => [1,4,2,3],
    :markersize => [3,9,5,7]
)

const styles = collect(keys(palette_dict))

function get_style(t::SelectedData, by = splitby(t))
    grpd = groupby(first, t.table, by)
    args_dict = Dict{Symbol, Any}()
    for (key, val) in t.categoricalstyle
        s = unique(sort(columns(grpd, key)))
        d = Dict(zip(s, 1:length(s)))
        args_dict[val] = reshape(palette_dict[val][map(t->getindex(d, t), columns(grpd, key))], 1, :)
    end
    args_dict
end
