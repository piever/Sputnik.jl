function loadbutton()
    s = choosefile(placeholder="Load file", accept=".csv")
    o = observe(s)
    on(launch, o) # print to console on every update
    tables = vcat("", readdir(tablefolder))
    d = dropdown(tables, label="saved")
    on(x -> x!="" && launch(JuliaDB.load(joinpath(tablefolder, x))), observe(d))
    hbox(d, hskip(20px), s)
end
