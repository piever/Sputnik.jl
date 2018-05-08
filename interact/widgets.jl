## Autocomplete
using WebIO, Vue, Blink
w = Window()
onSelect = """function (event){
    return this.choice = this.\$refs.ll.value;
}
"""
onSelect = WebIO.JSString(onSelect)

template = dom"div"(
        dom"input[list=lista, v-on:input=onSelect, ref=ll]"(),
        dom"datalist[id=lista]"(
            dom"option[value=xaa]"(),
            dom"option[value=xab]"()
        )
    )
o = Observable{Any}("")

ui = vue(template, ["choice"=>o], methods = Dict("onSelect"=>onSelect));
body!(w, ui)

## spinbox

function spinbox(label="";
                 value = 0)

     onChange = js"""function (event){
         return this.value = parseFloat(event)
     }
     """
    if !(value isa Observable)
        value = Observable{Any}(value)
    end
    template = dom"md-input-container"(
        dom"label"(label),
        dom"""md-input[v-on:change=onChange, type=number, min=0, max=10, step=2.5]"""(),
    )
    textbox = vue(template, ["value"=>value], methods = Dict("onChange" => onChange))
    primary_obs!(textbox, "value")
    slap_material_design!(textbox)
end

## Native input default
incoming = Observable{Any}("")
on(println, incoming) # print to console on every update

template = dom"input[type=text,v-model=message]"()
vue(template, [:message=>incoming]) |> dom"div"

## Native file input

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

## Autocomplete Vue material failing
template = dom"md-input-container"(dom"md-autocomplete[v-model=chosen, :md-options=options]"(
            dom"label"("label"),
          ))
labels_idxs = Dict("a"=>1, "b"=>2)
ui = vue(template, ["options" => labels_idxs, "chosen"=>Observable{Any}("")]) |> InteractNext.slap_material_design!
