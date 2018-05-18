# Default styles for Grammar of Graphics like interface
import ColorBrewer

const palette_dict = OrderedDict(
    :color => reshape(ColorBrewer.palette("Set1", 8), 1, :),
    :markershape => [:diamond :cross :circle :triangle],
)

const styles = collect(keys(palette_dict))
