### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 68de09ed-60e4-4049-bd9c-7ca9ed27c14f
using Test

# ╔═╡ f9c3ec24-9803-11ee-11c1-67df44e11392
md"
# AoC 2023
## Day 11
"

# ╔═╡ cdbc5bb2-bbe1-4a22-83df-2a9f972eb577
e1 = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""

# ╔═╡ a4c7d183-9dc6-4a75-8309-c46eb1717511
function expand2(gs, factor, rows, cols)
	exs = Array{Tuple{Int,Int}}(undef, length(gs)) # preallocate
	for (n, g) in enumerate(gs)
		i, j = g[1], g[2]
		x = count(<(i), rows)
		y = count(<(j), cols)
		exs[n] = (i+x*factor-x, j+y*factor-y)
	end
	exs
end

# ╔═╡ 7208f783-4b87-4f64-a974-bfda1b80578b
function emptyLines(map; dims=1)
	lines = []
	for (i, line) in enumerate(eachslice(map; dims=dims))
		if all(==(0), line)
			push!(lines, i)
		end
	end
	lines
end

# ╔═╡ f664e6b0-20e5-42cc-b0aa-0fa3784f7b23
function manhatan(a, b)
	abs(a[1]-b[1]) + abs(a[2]-b[2])
end

# ╔═╡ 88301337-4c0e-48e5-b61c-1c253e8bae2e
function getDistances(gs)
	g = length(gs)
	distances = Array{Pair{Tuple{Int,Int},Int}}(undef, (g^2 - g) ÷ 2) # preallocate
	n = 1
	for i in 1:g-1, j in i+1:g
		distances[n] = (i,j)=>manhatan(gs[i], gs[j])
		n += 1
	end
	distances
end

# ╔═╡ 0f4efc20-4f8f-4785-89b9-b1d068543a74
function getManhatanPairs(map)
	gs = findall(>(0), map)
	getDistances(gs)
end

# ╔═╡ 4f8612f3-39d3-4752-9b0f-4032eaa81d31
function expand(map)
	rs = []
	for row in eachslice(map; dims=1)
		if all(==(0), row)
			push!(rs, row)
		end
		push!(rs, row)
	end
	cs = []
	rs = stack(rs; dims=1)
	for col in eachslice(rs; dims=2)
		if all(==(0), col)
			push!(cs, col)
		end
		push!(cs, col)
	end
	cs = stack(cs; dims=2)
end

# ╔═╡ ab919b91-e4a4-43cd-9131-051bcb5cbf66
function parseMap(map)
	result = zeros(Int, length(map), length(map[1]))
	n = 1
	for i in eachindex(map), j in eachindex(map[1])
		if map[i][j] == '#'
			result[i,j] = n
			n += 1
		end
	end
	result
end

# ╔═╡ 8efcb24a-3bfd-4ce6-880c-1731ef0500c8
function p1(text; verbose=0)
	map = split(strip(text), "\n") |> parseMap
	0 < verbose && @info "map" map
	map = expand(map)
	0 < verbose && @info "expanded" map
	distances = getManhatanPairs(map)
	sum(Base.map(x->x.second, distances))
end

# ╔═╡ 00a2a02f-9e52-48cb-bd5a-4e5e0965c0aa
@time p1(e1; verbose=1)

# ╔═╡ 0cf77c73-4183-426c-9fba-aecec729a987
function p2(text, factor; verbose=0)
	map = split(strip(text), "\n") |> parseMap
	0 < verbose && display(map)
	rows = emptyLines(map; dims=1)
	cols = emptyLines(map; dims=2)
	gs = findall(>(0), map)
	gs = expand2(gs, factor, rows, cols)
	distances = getDistances(gs)
	sum(Base.map(x->x.second, distances))
end

# ╔═╡ e70e61b5-bb06-42e2-beb7-fcd6d8634769
@time p2(e1, 2; verbose=0)

# ╔═╡ 22a41dc5-a9b9-4596-ab06-d72fc967e7e7
@time p2(e1, 10)

# ╔═╡ c3ff1149-ef6b-4759-b809-d8669bd521b7
@time p2(e1, 100)

# ╔═╡ 4fa22a15-3a9c-4161-869f-e11ca772dee3
inp = open(joinpath(@__DIR__, "data", "input11"), "r") do f
	read(f, String)
end

# ╔═╡ b9c30af0-5b65-4e0e-85f8-0f67a7dee488
@time p1(inp)

# ╔═╡ a1d3bd7e-e5cc-47ff-a887-4fe5c672745d
@time p2(inp, 1000000)

# ╔═╡ 2bdfd707-514e-42e6-8e88-8e9d6197c6e0
begin
	@testset "Part 1" begin
		@test 374 == p1(e1)
		@test 9742154 == p1(inp)
	end
	@testset "Part 2" begin
		@test 374 == p2(e1, 2)
		@test 1030 == p2(e1, 10)
		@test 8410 == p2(e1, 100)
		@test 9742154 == p2(inp, 2)
		@test 411142919886 == p2(inp, 1000000)
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
# ╟─f9c3ec24-9803-11ee-11c1-67df44e11392
# ╠═cdbc5bb2-bbe1-4a22-83df-2a9f972eb577
# ╠═00a2a02f-9e52-48cb-bd5a-4e5e0965c0aa
# ╠═b9c30af0-5b65-4e0e-85f8-0f67a7dee488
# ╠═8efcb24a-3bfd-4ce6-880c-1731ef0500c8
# ╠═e70e61b5-bb06-42e2-beb7-fcd6d8634769
# ╠═22a41dc5-a9b9-4596-ab06-d72fc967e7e7
# ╠═c3ff1149-ef6b-4759-b809-d8669bd521b7
# ╠═a1d3bd7e-e5cc-47ff-a887-4fe5c672745d
# ╠═0cf77c73-4183-426c-9fba-aecec729a987
# ╠═a4c7d183-9dc6-4a75-8309-c46eb1717511
# ╠═7208f783-4b87-4f64-a974-bfda1b80578b
# ╠═0f4efc20-4f8f-4785-89b9-b1d068543a74
# ╠═88301337-4c0e-48e5-b61c-1c253e8bae2e
# ╠═f664e6b0-20e5-42cc-b0aa-0fa3784f7b23
# ╠═4f8612f3-39d3-4752-9b0f-4032eaa81d31
# ╠═ab919b91-e4a4-43cd-9131-051bcb5cbf66
# ╠═2bdfd707-514e-42e6-8e88-8e9d6197c6e0
# ╟─4fa22a15-3a9c-4161-869f-e11ca772dee3
# ╟─68de09ed-60e4-4049-bd9c-7ca9ed27c14f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
