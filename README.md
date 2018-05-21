# Sputnik

[![Build Status](https://travis-ci.org/piever/Sputnik.jl.svg?branch=master)](https://travis-ci.org/piever/Sputnik.jl)
[![codecov.io](http://codecov.io/github/piever/Sputnik.jl/coverage.svg?branch=master)](http://codecov.io/github/piever/Sputnik.jl?branch=master)

A web-app for data visualization based on Julia Gizmos and JuliaDB. Heavily wip, here's a video showing how it works:

[<img src="https://user-images.githubusercontent.com/6333339/37868363-d59c85fc-2f9c-11e8-97ee-e97d89b5ba10.png" width="489">](https://vimeo.com/261643164)

## Getting started

The package is not released (and in alpha state) so installing it is somewhat laborious.

To install Sputnik and its dependencies type in the REPL:

```julia
Pkg.clone("https://github.com/piever/Sputnik.jl")
Pkg.clone("https://github.com/piever/InteractBase.jl")
Pkg.clone("https://github.com/piever/InteractBulma.jl")
Pkg.build("https://github.com/piever/InteractBulma.jl")
Pkg.clone("https://github.com/JuliaComputing/TableView.jl")
```

Then:

```julia
using Sputnik
Sputnik.launch()
```

should get you started.
