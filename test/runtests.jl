using JuliaDB, GroupedErrors, Sputnik, Images
using Sputnik: process
using StatsPlots
using Test
school = loadtable(GroupedErrors.exampletable("school.csv"))

function compare_plots(plt1, plt2; sigma = [1,1], eps = 0.02)
    ref1 = joinpath(@__DIR__, "plots", "plot1.png")
    savefig(plt1, ref1)
    ref2 = joinpath(@__DIR__, "plots", "plot2.png")
    savefig(plt2, ref2)
    outcome = Images.test_approx_eq_sigma_eps(Images.load(ref1), Images.load(ref2), sigma, eps)
    rm(ref1)
    rm(ref2)
    outcome
end

@testset "statplots" begin
    data = school
    sd = SelectedData(school)

    a = Analysis(data = sd, x = :MAch, plot = density)
    plt1 = process(a)
    plt2 = @df data density(:MAch)
    @test compare_plots(plt1, plt2) < 0.005

    a = Analysis(data = sd, x = :MAch, y = :SSS, plot = scatter, plot_kwargs = [(:legend, :topleft)])
    plt1 = process(a)
    plt2 = @df data scatter(:MAch, :SSS, legend = :topleft)
    @test compare_plots(plt1, plt2) < 0.005

    sd = SelectedData(school)
    a = Analysis(data = sd, x = :MAch, y = :SSS, plot = scatter)
    plt1 = process(a)
    plt2 = @df school scatter(:MAch, :SSS, legend = false)
    @test compare_plots(plt1, plt2) < 0.005
end

@testset "groupederrors" begin
    sd = SelectedData(school)
    a = Analysis(data = sd,
                 x = :MAch,
                 y = :density,
                 plot = plot,
                 axis_type = :continuous,
                 smoother = 50.0)
    plt1 = process(a)
    plt2 = @> data begin
        @x _.MAch :continuous
        @y :density bandwidth = (51.0)*std(column(data, :MAch))/200
        @plot plot()
    end
    @test compare_plots(plt1, plt2) < 0.005

    a = Analysis(data = sd,
                 compute_error = (:across, :School),
                 x = :MAch,
                 y = :density,
                 plot = plot,
                 axis_type = :continuous,
                 smoother = 50.0)
    plt1 = process(a)
    plt2 = @> data begin
        @across _.School
        @x _.MAch :continuous
        @y :density bandwidth = (51.0)*std(column(data, :MAch))/200
        @plot plot()
    end
    @test compare_plots(plt1, plt2) < 0.005

    a = Analysis(data = sd,
                 compute_error = (:across, :School),
                 x = :MAch,
                 y = :SSS,
                 xfunc = mean,
                 yfunc = mean,
                 plot = scatter,
                 axis_type = :pointbypoint)
    plt1 = process(a)
    plt2 = @> data begin
        @across _.School
        @x _.MAch
        @y _.SSS
        @plot scatter()
    end
    @test compare_plots(plt1, plt2) < 0.005
end
