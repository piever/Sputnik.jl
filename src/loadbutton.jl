function loadbutton()
    s = choosefile(placeholder="Load file", accept=".csv")
    on(launch, observe(s)) # print to console on every update
    s
end

function loadfrommemory()
    tables = vcat("", readdir(tablefolder))
    d = dropdown(tables, label="saved")
    on(x -> x!="" && launch(JuliaDB.load(joinpath(tablefolder, x))), observe(d))
    d
end
