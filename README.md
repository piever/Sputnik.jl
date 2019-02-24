# Sputnik

[![Build Status](https://travis-ci.org/piever/Sputnik.jl.svg?branch=master)](https://travis-ci.org/piever/Sputnik.jl)
[![codecov.io](http://codecov.io/github/piever/Sputnik.jl/coverage.svg?branch=master)](http://codecov.io/github/piever/Sputnik.jl?branch=master)

A web-app for data visualization based on Julia Gizmos and JuliaDB.

## Getting started

The package is not released (and in alpha state), to install Sputnik and its dependencies activate the package REPL by typing `]` and then type:

```julia
add https://github.com/piever/Sputnik.jl
```

Then:

```julia
using Sputnik
Sputnik.launch()
```

should get you started: click on the upload button to load a csv.
