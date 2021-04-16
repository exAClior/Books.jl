@memoize function default_metadata()::Dict
    path = joinpath(DEFAULTS_DIR, "Metadata.yml")
    data = YAML.load_file(path)
end

function user_metadata()
    path = "Metadata.yml"
    isfile(path) ? YAML.load_file(path) : error("Couldn't find Metadata.yml")
end

"""
    override(d1::Dict, d2::Dict)

Merge `d1` and `d2` by overriding values existing in `d1` by values from `d2`.

# Example
```jldoctest
julia> d1 = Dict(:A => 1, :B => 2);

julia> d2 = Dict(:A => 3, :C => 4);

julia> Books.override(d1, d2)
Dict{Symbol, Int64} with 3 entries:
  :A => 3
  :B => 2
  :C => 4
```
"""
override(d1::Dict, d2::Dict) = Dict(d1..., d2...)

"""
    write_metadata()

Write `Metadata.yml` for Pandoc to $(Books.GENERATED_DIR).
The file is a combination of Books.jl default settings and the user-defined settings.
"""
function write_metadata()
    default = default_metadata()
    user = user_metadata()
    combined = override(default, user)
    mkpath(GENERATED_DIR)
    path = joinpath(GENERATED_DIR, "Metadata.yml")
    YAML.write_file(path, combined)
end

"""
    project_info(path, project::AbstractString)

Return project info for TOML file at `path` as raw text or `nothing` if `project` is not defined.
"""
function project_info(path, project::AbstractString)
    text = read(path, String)
    dic = TOML.parse(text)
    project in keys(dic["projects"]) ?
        dic["projects"][project] :
        nothing
end

@memoize function default_config(project::AbstractString)
    path = joinpath(DEFAULTS_DIR, "Config.toml")
    project_info(path, project)
end

function user_config(project::AbstractString)
    path = "Config.toml"
    isfile(path) ? project_info(path, project) : nothing
end

"""
    config(project::AbstractString)

Read user `Config.toml` and `$DEFAULTS_DIR/Config.toml` and combine the information.

# Example
```jldoctest
julia> cd(joinpath(pkgdir(Books), "docs"))

julia> Books.config("default")
Dict{String, Any} with 5 entries:
  "port"              => 8010
  "contents"          => ["about", "getting-started", "demo", "references"]
  "output_filename"   => "books"
  "online_url_prefix" => "Books.jl"
  "extra_directories" => ["images"]
```
"""
function config(project::AbstractString)
    default = default_config(project)
    user = user_config(project)
    combined =
        isnothing(user) && isnothing(default) ? error("Project $project not defined in Config.toml") :
        isnothing(user) ? default :
        isnothing(default) ? user :
        override(default, user)
end
