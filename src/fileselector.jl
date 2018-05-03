o = Observable{Any}("")
on(println, o) # print to console on every update
data = Dict("filename" => o )
ui = vue(dom"input[ref=data, type=file, id=input, v-on:change=onFileChange]"(),
    data, methods = Dict(:onFileChange =>
        WebIO.JSString("(function (event){return this.filename = this.\$refs.data.files[0].name})"))) |> dom"div"
