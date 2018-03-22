# Abstract

We will combine the JuliaDB.jl package, for tabular data manipulations in Julia, with WebIO.jl and InteractNext.jl to build a user-friendly web-based app for data analysis and visualizations.

We will draw from PlugAndPlot.jl, a previous attempt based on QML and focused on the analysis of population data. The advantages of the new JuliaDB/WebIO based approach are:

- we can exploit JuliaDB's unique features, such as parallel storage and computing, support for online statistical techniques and machine learning techniques
- WebIO allows deploying in a wide variety of frameworks: the Julia IDE Juno's plot pane, Jupyter notebook, an Electron window or a web page via Mux.jl

The web page deployment is particularly relevant in our view as it allows to make interactive data visualizations easily accessible online.

Finally, rather than building a monolithic app, we will modularize our design to the extent possible, thus allowing different projects to reuse parts of it to create GUIs with different designs or based on different algorithms and visualization packages.
