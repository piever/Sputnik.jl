module Sputnik

using Statistics
using Interact
using StatsPlots
using DataStructures
using JuliaDB, DataStructures
import Observables: AbstractObservable, observe
using MacroTools
using GroupedErrors
using JuliaDB, IndexedTables
using Parameters
using Blink, Mux

import IndexedTables: AbstractIndexedTable
import TableWidgets

export SelectedData
export Analysis

const tablefolder = joinpath(homedir(), ".sputnik", "tables")
const plotfolder = joinpath(homedir(), ".sputnik", "plots")

include("selectdata.jl")
include("defaultstyles.jl")
include("process.jl")
include(joinpath("techniques", "statplotsrecipe.jl"))
include(joinpath("techniques", "groupederrors.jl"))
include(joinpath("techniques", "table.jl"))


include("dropdownmenus.jl")
include("stylechooser.jl")
include("loadbutton.jl")
include("localsave.jl")
include("launch.jl")
include("plot.jl")

end # module
