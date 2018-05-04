function loadbutton()
    o = Observable{Any}("")
    on(launch, o) # print to console on every update
    data = Dict("filename" => o )

    s = """function (event){
        var filePath = this.\$refs.data;
        var fn = filePath.files[0];
        return this.filename = fn.path
    }
    """
    jfunc = WebIO.JSString(s)

    ui = vue(dom"input[ref=data, type=file, id=input, v-on:change=onFileChange]"(),
        data, methods = Dict(:onFileChange => jfunc))

    tables = vcat("", readdir(tablefolder))
    d = dropdown(tables)
    on(x -> x!="" && launch(JuliaDB.load(joinpath(tablefolder, x))), observe(d))
    hbox(pad((:top, :left), 20px, ui), d) |> dom"div"
end
