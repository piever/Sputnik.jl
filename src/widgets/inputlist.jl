function inputlist(options; label = "", placeholder = options[1])
    onSelect = """function (event){
        return this.text = this.\$refs.listref.value;
    }
    """
    onSelect = WebIO.JSString(onSelect)
    args = [dom"option[value=$opt]"() for opt in options]
    s = gensym()
    template = dom"div"(
        dom"label"(label),
        dom"br"(),
        dom"input[list=$s, v-on:input=onSelect, ref=listref, value=$placeholder]"(),
        dom"datalist[id=$s]"(args...)
    )
    o = Observable(placeholder)
    ui = vue(template, ["text"=>o], methods = Dict("onSelect"=>onSelect));
    InteractNext.primary_obs!(ui, "text")
    ui
end
