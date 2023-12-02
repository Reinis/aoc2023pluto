### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ fcd41ee2-d09a-4178-b4b2-4ef4b5c42129
using Test

# ╔═╡ 9b3d2012-90f1-11ee-3943-f5c1f8a8f3d0
md"
# AoC 2023
## Day 2
"

# ╔═╡ 7172ffb2-fae7-4590-ae46-da333f63018a
e1 = """
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""

# ╔═╡ 8c812f08-081a-42c4-b29d-15c7b63c91de
function possible(subsets)
	for subset in subsets
		if 12 < subset.r || 13 < subset.g || 14 < subset.b
			return false
		end
	end
	return true
end

# ╔═╡ 4b800449-f2d8-4901-b3c4-bb82acdecdc1
function getPower(subsets)
	r = 0
	g = 0
	b = 0
	for subset in subsets
		if r < subset.r
			r = subset.r
		end
		if g < subset.g
			g = subset.g
		end
		if b < subset.b
			b = subset.b
		end
	end
	return r * g * b
end

# ╔═╡ c5b25e46-a9fc-4ced-af8f-a12a4535f9fe
mutable struct Subset
	r::Int16
	g::Int16
	b::Int16
end

# ╔═╡ bdaa6ee2-4d62-4798-a0eb-9bf4b1c65745
function parseSubset(text)
	splitComma = x -> split(x, ", ")
	splitSpace = x -> split(x, " ")
	pairs = text |> splitComma .|> splitSpace
	subset = Subset(0, 0, 0)
	for p in pairs
		c = p[2]
		n = parse(Int16, p[1])
		if c == "red"
			subset.r = n
		elseif c == "green"
			subset.g = n
		elseif c == "blue"
			subset.b = n
		end
	end
	return subset
end

# ╔═╡ 1c1a2971-711a-4739-995b-45f7401a23a0
function parseGame(line)
	game, data = split(line, ": ")
	index = parse(Int16, replace(game, "Game "=>""))
	data = split(data, "; ")
	subsets = parseSubset.(data)
	return index, subsets
end

# ╔═╡ aacf2527-ebaf-4780-8682-f17bd2c7cc1e
function getData(text)
	lines = split(strip(text), "\n")
	games = Dict{Int16, Vector{Subset}}()
	for line in lines
		i, subsets = parseGame(line)
		setindex!(games, subsets, i)
	end
	return games
end

# ╔═╡ cefaf672-af9a-47c1-8ca0-711ae30e58cc
function p1(text; verbose=0)
	data = getData(text)
	impossible = []
	for (i, v) in pairs(data)
		if possible(v)
			push!(impossible, i)
		end
	end
	0 < verbose && println(impossible)
	return sum(impossible)
end

# ╔═╡ c873e3e1-0432-459e-8b94-03bf80ee8899
p1(e1; verbose=1)

# ╔═╡ d1fd5d9b-5f76-46c4-a6db-9bb1544ee728
function p2(text; verbose=0)
	data = getData(text)
	powers = []
	for v in values(data)
		p = getPower(v)
		push!(powers, p)
	end
	0 < verbose && println(powers)
	return sum(powers)
end

# ╔═╡ 4c94c198-8b48-4c90-ae06-7db72294d879
p2(e1; verbose=1)

# ╔═╡ 51e32f21-b87b-4ff7-a4ae-5599b6f8f27b
getData(e1)

# ╔═╡ 4e290e0b-7191-4ce5-9910-dffd0aa500b0
inp = open(joinpath(@__DIR__, "data", "input02"), "r") do f
	read(f, String)
end

# ╔═╡ f9ad242e-eac9-4f3a-9d5d-de7894ce91b8
p1(inp)

# ╔═╡ a28cb4c9-1958-4efb-b2b7-b1f4310bdabf
p2(inp)

# ╔═╡ f04bed8f-6ce6-4746-b2cd-621a248798fa
begin
	@testset "Part 1" begin
		@test 8 == p1(e1)
		@test 2256 == p1(inp)
	end
	@testset "Part 2" begin
		@test 2286 == p2(e1)
		@test 74229 == p2(inp)
	end
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
manifest_format = "2.0"
project_hash = "71d91126b5a1fb1020e1098d9d492de2a4438fd2"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ Cell order:
# ╟─9b3d2012-90f1-11ee-3943-f5c1f8a8f3d0
# ╠═7172ffb2-fae7-4590-ae46-da333f63018a
# ╠═c873e3e1-0432-459e-8b94-03bf80ee8899
# ╠═f9ad242e-eac9-4f3a-9d5d-de7894ce91b8
# ╠═cefaf672-af9a-47c1-8ca0-711ae30e58cc
# ╠═4c94c198-8b48-4c90-ae06-7db72294d879
# ╠═a28cb4c9-1958-4efb-b2b7-b1f4310bdabf
# ╠═d1fd5d9b-5f76-46c4-a6db-9bb1544ee728
# ╠═8c812f08-081a-42c4-b29d-15c7b63c91de
# ╠═4b800449-f2d8-4901-b3c4-bb82acdecdc1
# ╠═51e32f21-b87b-4ff7-a4ae-5599b6f8f27b
# ╠═aacf2527-ebaf-4780-8682-f17bd2c7cc1e
# ╠═1c1a2971-711a-4739-995b-45f7401a23a0
# ╠═bdaa6ee2-4d62-4798-a0eb-9bf4b1c65745
# ╠═c5b25e46-a9fc-4ced-af8f-a12a4535f9fe
# ╠═f04bed8f-6ce6-4746-b2cd-621a248798fa
# ╟─4e290e0b-7191-4ce5-9910-dffd0aa500b0
# ╟─fcd41ee2-d09a-4178-b4b2-4ef4b5c42129
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
