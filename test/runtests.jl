using JuliaDB, Compat, GroupedErrors, Sputnik, Images, NamedTuples
using StatPlots
using Compat.Test
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

@testset "select" begin
    selectdiscrete = (SelectValues(:Minrty, ["Yes"], true), SelectValues(:Sx, ["Male"], false))
    selectcontinuous = (SelectPredicate(:MAch, x -> 6 <= x <= 10),)
    expected = filter(i -> i.Minrty == "Yes" && i.Sx == "Male" && 6 <= i.MAch <= 10, school)
    @test Sputnik.selectdata(school, selectdiscrete, selectcontinuous) == expected
    d2s  = Data2Select(school, selectdiscrete, selectcontinuous)
    @test SelectedData(d2s) == SelectedData(expected, (:Minrty,))
end

@testset "statplots" begin
    selectdiscrete = (SelectValues(:Minrty, String[], true, false), SelectValues(:Sx, ["Male"], false))
    selectcontinuous = (SelectPredicate(:MAch, x -> 6 <= x <= 10),)
    expected = filter(i -> i.Sx == "Male" && 6 <= i.MAch <= 10, school)
    d2s  = Data2Select(school, selectdiscrete, selectcontinuous)
    sd = SelectedData(d2s)

    a = Analysis(data = sd, x = :MAch, plot = density)
    plt1 = process(a)
    plt2 = @df expected density(:MAch, group = {:Minrty})
    @test compare_plots(plt1, plt2) < 0.001

    a = Analysis(data = sd, x = :MAch, y = :SSS, plot = scatter, plot_kwargs = [(:legend, :topleft)])
    plt1 = process(a)
    plt2 = @df expected scatter(:MAch, :SSS, legend = :topleft, group ={:Minrty})
    @test compare_plots(plt1, plt2) < 0.001

    sd = SelectedData(Data2Select(school, (), ()))
    a = Analysis(data = sd, x = :MAch, y = :SSS, plot = scatter)
    plt1 = process(a)
    plt2 = @df school scatter(:MAch, :SSS, legend = false)
    @test compare_plots(plt1, plt2) < 0.001
end

@testset "groupederrors" begin
    school = GroupedErrors.exampletable("school.csv") |> loadtable
    selectdiscrete = (SelectValues(:Minrty, ["Yes", "No"], true), SelectValues(:Sx, ["Male"], false))
    selectcontinuous = (SelectPredicate(:MAch, x -> 6 <= x <= 10),)
    expected = filter(i -> i.Sx == "Male" && 6 <= i.MAch <= 10, school)
    d2s  = Data2Select(school, selectdiscrete, selectcontinuous)
    sd = SelectedData(d2s)
    a = Analysis(data = sd,
                 x = :MAch,
                 y = :density,
                 plot = plot,
                 axis_type = :continuous,
                 smoother = 50.0)
    plt1 = process(a)
    plt2 = @> expected begin
        @splitby _.Minrty
        @x _.MAch :continuous
        @y :density bandwidth = (51.0)*std(column(expected, :MAch))/200
        @plot plot()
    end
    @test compare_plots(plt1, plt2) < 0.001

    a = Analysis(data = sd,
                 compute_error = (:across, :School),
                 x = :MAch,
                 y = :density,
                 plot = plot,
                 axis_type = :continuous,
                 smoother = 50.0)
    plt1 = process(a)
    plt2 = @> expected begin
        @across _.School
        @splitby _.Minrty
        @x _.MAch :continuous
        @y :density bandwidth = (51.0)*std(column(expected, :MAch))/200
        @plot plot()
    end
    @test compare_plots(plt1, plt2) < 0.001

    a = Analysis(data = sd,
                 compute_error = (:across, :School),
                 x = :MAch,
                 y = :SSS,
                 xfunc = mean,
                 yfunc = mean,
                 plot = scatter,
                 axis_type = :pointbypoint)
    plt1 = process(a)
    plt2 = @> expected begin
        @across _.School
        @splitby _.Minrty
        @x _.MAch
        @y _.SSS
        @plot scatter()
    end
    @test compare_plots(plt1, plt2) < 0.001
end
