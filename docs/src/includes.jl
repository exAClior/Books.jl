function homepage_intro()
    books_project_path = joinpath(pkgdir(Books), "Project.toml")
    project_info = read(books_project_path, String)
    project_info = TOML.parse(project_info)

    books_version = project_info["version"]
    text = """
    This website introduces and demonstrates the package
    [`Books.jl`](https://github.com/JuliaBooks/Books.jl){target="_blank"}
    at version $books_version and is available as
    [**PDF**](/books.pdf){target="_blank"}.
    These pages were built on $(today()) with Julia $VERSION.
    """
end

serve_example() = code_block(raw"""
    $ julia --project -e 'using Books; serve()'
    Watching ./pandoc/favicon.png
    Watching ./src/plots.jl
    [...]
     ✓ LiveServer listening on http://localhost:8001/ ...
      (use CTRL+C to shut down)
    """)

gen_function_docs() = Books.doctest(@doc gen(::Function))

function docs_metadata()
    path = joinpath(pkgdir(BooksDocs), "metadata.yml")
    text = read(path, String)
    text = replace(text, '`' => "\\`")
    output_block(text)
end

function default_metadata()
    path = joinpath(Books.DEFAULTS_DIR, "metadata.yml")
    text = read(path, String)
    output_block(text)
end

function docs_config()
    path = joinpath(pkgdir(BooksDocs), "config.toml")
    text = read(path, String)
    output_block(text)
end

function default_config()
    path = joinpath(Books.DEFAULTS_DIR, "config.toml")
    text = read(path, String)
    output_block(text)
end

my_table() = DataFrame(U = [1, 2], V = [:a, :b], W = [3, 4])

function multiple_df_vector()
    [DataFrame(Z = [3]), DataFrame(U = [4, 5], V = [6, 7])]
end

function multiple_df_example()
    objects = [
        DataFrame(X = [3, 4], Y = [5, 6]),
        DataFrame(U = [7, 8], V = [9, 10])
    ]
    filenames = ["a", "b"]
    Options.(objects, filenames)
end

sum_example() = code("""
    a = 2
    b = 3

    a + b
    """)

sum_example_definition() = code_block(@code_string sum_example())

example_table() = DataFrame(A = [1, 2], B = [3, 4], C = [5, 6])
example_table_definition() = code_block(@code_string example_table())

export my_data
function my_data()
    DataFrame(A = [1, 2], B = [3, 4], C = [5, 6], D = [7, 8])
end

function my_data_mean(df::DataFrame)
    Statistics.mean(df.A)
end

hello(name) = "Hello, $name"

function options_example()
    df = DataFrame(A=[1], B=[2], C=[3])
    caption = "My DataFrame."
    label = "foo"
    return Options(df; caption, label)
end

options_example_doctests() = Books.doctest(@doc Books.caption_label)

code_example_table() = code("""
    using DataFrames

    DataFrame(A = [1, 2], B = [3, 4], C = [5, 6])
    """)

julia_version_example() = """
```output
This book is built with Julia $VERSION.
```"""

module U end

function module_example()
    code("x = 3"; mod=U)
end

module_call_x() = code("x"; mod=U)

module_fail() = code("DataFrame(A = [1], B = [2])"; mod=U)

module_fix() = code("""
    using DataFrames

    DataFrame(A = [1], B = [2])"""; mod=U)

module_example_definition() = code_block("""
    module U end
    $(@code_string module_example())
    """)

function example_plot()
    I = 1:30
    plot(I, I.^2)
end

function multiple_example_plots()
    filenames = ["example_plot_$i" for i in 2:3]
    I = 1:30
    objects = [
        plot(I, I.^2),
        scatter(I, I.^3)
    ]
    return Options.(objects, filenames)
end

function image_options_plot()
    I = 1:30
    fig = Figure(; resolution=(600, 140))
    ax = Axis(fig[1, 1]; xlabel="x", ylabel="y")
    scatterlines!(ax, I, 3 .* sin.(I))
    return fig
end

function combined_options_plot()
    fg = image_options_plot()
    Options(fg; caption="Sine function.")
end

function plotsjl()
    p = plot(1:10, 1:2:20)
    caption = "An example plot with Plots.jl."
    # Label defaults to `nothing`, which will not create a cross-reference.
    label = missing
    Options(p; caption, label)
end

function makiejl()
    x = range(0, 10, length=100)
    y = sin.(x)
    p = lines(x, y)
    caption = "An example plot with Makie.jl."
    label = "makie"
    link_attributes = "width=70%"
    Options(p; caption, label, link_attributes)
end

const BACKTICK = '`'
export BACKTICK
