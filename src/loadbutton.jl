function loadbutton(ui)
    s = choosefile(placeholder="Load file", accept=".csv")
    on(t -> set_ui!(ui, t), observe(s)) # print to console on every update
    s
end

function loadfrommemory(ui)
    tables = vcat("", readdir(tablefolder))
    d = dropdown(tables, label="saved")
    on(x -> x!="" && set_ui!(ui, JuliaDB.load(joinpath(tablefolder, x))), observe(d))
    d
end
