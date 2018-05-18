module Sputnik

using InteractBase
using InteractSpectre
using StatPlots
using WebIO, Vue, CSSUtil, JuliaDB, DataStructures, Observables
import InteractBase: primary_obs!, observe
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

include("defaultstyles.jl")
include("selectdata.jl")
include("process.jl")
include(joinpath("techniques", "statplotsrecipe.jl"))
include(joinpath("techniques", "groupederrors.jl"))
include(joinpath("techniques", "table.jl"))


include("checklistcolumn.jl")
include("dropdownmenus.jl")
include("stylechooser.jl")
include("loadbutton.jl")
include("localsave.jl")
include("layout.jl")
include("launch.jl")
include("plot.jl")

end # module
