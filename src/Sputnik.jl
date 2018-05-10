module Sputnik

using InteractNative, WebIO, Vue, CSSUtil, JuliaDB, StatPlots, DataStructures, Observables
import GR
using MacroTools
using GroupedErrors
using JuliaDB, IndexedTables, NamedTuples
using Parameters
using TableView
using Blink, Mux

import IndexedTables: AbstractIndexedTable

export Data2Select, SelectedData
export SelectPredicate, SelectValues
export Analysis, process
export layout, ChecklistColumn, checklistcolumns

const tablefolder = joinpath(homedir(), ".sputnik", "tables")
const plotfolder = joinpath(homedir(), ".sputnik", "plots")

include("widgets/inputlist.jl")
include("selectdata.jl")
include("process.jl")
include(joinpath("techniques", "statplotsrecipe.jl"))
include(joinpath("techniques", "groupederrors.jl"))
include(joinpath("techniques", "table.jl"))


include("checklistcolumn.jl")
include("dropdownmenus.jl")
include("loadbutton.jl")
include("localsave.jl")
include("layout.jl")
include("launch.jl")
include("plot.jl")

end # module
