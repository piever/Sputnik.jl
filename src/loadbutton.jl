function loadbutton(ui)
    s = filepicker(placeholder="Load file", accept=".csv")
    on(t -> set_ui!(ui, t), observe(s)) # print to console on every update
    s
end

function loadfrommemory(ui)
    tables = readdir(tablefolder)
    d = dropdown(tables, placeholder="Previously saved", value = nothing)
    on(x -> x!="" && set_ui!(ui, JuliaDB.load(joinpath(tablefolder, x))), observe(d))
    d
end
