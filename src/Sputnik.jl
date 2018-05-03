module Sputnik

using InteractNext, WebIO, Vue, CSSUtil, JuliaDB, StatPlots, DataStructures, Observables
import GR
using MacroTools
using GroupedErrors
using JuliaDB, IndexedTables, NamedTuples
using Parameters
using TableView

import IndexedTables: AbstractIndexedTable

export Data2Select, SelectedData
export SelectPredicate, SelectValues
export Analysis, process
export layout, ChecklistColumn, checklistcolumns


include("selectdata.jl")
include("process.jl")
include(joinpath("techniques", "statplotsrecipe.jl"))
include(joinpath("techniques", "groupederrors.jl"))
include(joinpath("techniques", "table.jl"))


include("checklistcolumn.jl")
include("dropdownmenus.jl")
include("loadbutton.jl")
include("layout.jl")
include("launch.jl")
include("plot.jl")

end # module
