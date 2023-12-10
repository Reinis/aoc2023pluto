### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 8f804d9b-88b0-4747-913b-aa20e4308858
using Test

# ╔═╡ d661eefc-9759-11ee-1a2d-0377005c6484
md"
# AoC 2023
## Day 10
"

# ╔═╡ eec93fec-cde2-4fb2-aeaf-77a267f50a9c
e1 = """
.....
.S-7.
.|.|.
.L-J.
.....
"""

# ╔═╡ a138ae04-a8fb-491c-8d43-41f02878a589
e2 = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""

# ╔═╡ d5e00934-dd0b-46dc-8cbc-5328050e9505
e3 = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........
"""

# ╔═╡ ea571259-d88a-444b-a8c1-e54e9e6899f5
e4 = """
..........
.S------7.
.|F----7|.
.||....||.
.||....||.
.|L-7F-J|.
.|..||..|.
.L--JL--J.
..........
"""

# ╔═╡ dc65b9cc-70fd-48ed-a085-d02c837becfc
e5 = """
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
"""

# ╔═╡ 4d0359cd-b933-4a86-aae6-645839233cef
e6 = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""

# ╔═╡ 2226c541-f4c8-4e14-9e71-f93be025ab60
function replaceStart(map, loop; verbose=0)
	x, y = first(loop)
	i, j = loop[2]
	k, l = last(loop)
	a = map[i][j]
	b = map[k][l]
	s = 'S'
	if i == k
		s = '-'
	elseif j == l
		s = '|'
	elseif i < x || k < x # above
		if j < y || l < y # left
			s = 'J'
		else
			s = 'L'
		end
	else # below
		if j < y || l < y # left
			s = '7'
		else
			s = 'F'
		end
	end
	0 < verbose && @info "start" a => (i,j) s => (x,y) b => (k,l)
	map[x] = map[x][1:y-1] * s * map[x][y+1:end]
	map
end

# ╔═╡ dc46f88d-8f45-4cdf-9681-48e89dcd5eba
function markInner(map, tiles)
	map = split.(map, "") .|> x->only.(x)
	for (i,j) in tiles
		map[i][j] = 'I'
	end
	join.(map)
end

# ╔═╡ e41c45d6-4bc7-4fee-af1e-81df3113cd63
function getH(map)
	h = Set()
	for i in eachindex(map)
		inner = false
		prev = '.'
		for j in eachindex(map[1])
			c = map[i][j]
			if c in "|LFJ7"
				if c in "|FL" || prev in "L" && c in "J" || prev in "F" && c in "7"
					inner = !inner
				end
				prev = c
				continue
			end
			if inner && c == '.'
				push!(h, (i,j))
			end
		end
	end
	h
end

# ╔═╡ ea73a960-21e2-42e5-b309-96a2b1ec6338
function clear(map, loop)
	map = split.(map, "") .|> x->only.(x)
	for i in eachindex(map), j in eachindex(map[1])
		if (i,j) ∉ loop
			map[i][j] = '.'
		end
	end
	join.(map)
end

# ╔═╡ fdac1904-ecb6-43d7-8216-8a332b3034a9
function countInner(map, loop; verbose=0)
	map = clear(map, loop)
	0 < verbose && @info "map" map
	map = replaceStart(map, loop; verbose)
	1 < verbose && display(map)
	h = getH(map)
	0 < verbose && @info "inner" length(h) h markInner(map, h)
	length(h)
end

# ╔═╡ 040e6ae9-2b85-4cd2-9426-650d01afc157
function isConnected(map, x, y, i, j)
	p = map[x][y]
	c = map[i][j]
	if y == j # vertical
		if x > i && c in "|F7" && p in "S|LJ" # above
			return true
		elseif x < i && c in "|LJ" && p in "S|F7" # below
			return true
		end
	else # horizontal
		if y > j && c in "-FL" && p in "S-7J" # left
			return true
		elseif y < j && c in "-7J" && p in "S-FL" # right
			return true
		end
	end
	return false
end

# ╔═╡ 438639d2-6d45-4806-a61f-5dca0194d497
function getNext(map, path)
	x, y = last(path)
	# println("$x $y $(map[x][y]) current")
	xmin = max(1, x-1)
	xmax = min(length(map), x+1)
	ymin = max(1, y-1)
	ymax = min(length(map[1]), y+1)
	for i in xmin:xmax
		for j in ymin:ymax
			if x == i && y == j || x != i && y != j
				continue
			end
			if isConnected(map, x, y, i, j) && (i,j) ∉ path
				# println("$i $j $(map[i][j]) connected")
				return i, j
			else
				# println("$i $j $(map[i][j]) not")
			end
		end
	end
	first(path)
end

# ╔═╡ 5867bf29-1ff5-4ccd-bb4c-c8a31eb2e0f1
function getLoop(map, start)
	path = [start]
	x, y = getNext(map, path)
	while map[x][y] != 'S'
		push!(path, (x,y))
		x, y = getNext(map, path)
	end
	path
end

# ╔═╡ 71adbe16-d575-4179-ba67-829f5a81071a
function findStart(map)
	for row in eachindex(map), col in eachindex(map[1])
		if map[row][col] == 'S'
			return row, col
		end
	end
end

# ╔═╡ 30ef855c-cb40-4dad-922f-1867f1859001
function p1(text)
	map = split(strip(text), "\n")
	start = findStart(map)
	loop = getLoop(map, start)
	length(loop) ÷ 2
end

# ╔═╡ 57750046-e064-4afe-a550-7e0c7f6f3dd0
@time p1(e1)

# ╔═╡ f74dcdeb-b31a-4304-bf3a-25c1c84dafd6
@time p1(e2)

# ╔═╡ 0c9d20bd-5790-4b39-a52d-eff26b8b669e
function p2(text; verbose=0)
	map = split(strip(text), "\n")
	start = findStart(map)
	loop = getLoop(map, start)
	countInner(map, loop; verbose)
end

# ╔═╡ ed691326-3005-4280-aa73-553164d7fa77
@time p2(e3; verbose=1)

# ╔═╡ dae62d82-b345-4868-847d-156f0b0813a0
@time p2(e4; verbose=1)

# ╔═╡ 82782605-eb75-4926-9325-dda5ed3dcb7a
@time p2(e5; verbose=1)

# ╔═╡ e5bcfb58-6afa-4cd2-ae9e-907eb4e48961
@time p2(e6; verbose=1)

# ╔═╡ c58331c5-460f-40de-81e7-ed66628dc0ce
inp = open(joinpath(@__DIR__, "data", "input10"), "r") do f
	inp2 = read(f, String)
end

# ╔═╡ 8193b197-a4ca-4b5e-b80e-47f9ac38fb5d
@time p1(inp)

# ╔═╡ da70e4b9-186b-44e1-a340-46cd827334e5
@time p2(inp)

# ╔═╡ c22da381-5e5a-41b1-948b-28b29c9d324c
begin
	@testset "Part 1" begin
		@test 4 == p1(e1)
		@test 8 == p1(e2)
		@test 6754 == p1(inp)
	end
	@testset "Part 2" begin
		@test 4 == p2(e3)
		@test 4 == p2(e4)
		@test 8 == p2(e5)
		@test 10 == p2(e6)
		@test 567 == p2(inp)
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
# ╟─d661eefc-9759-11ee-1a2d-0377005c6484
# ╠═eec93fec-cde2-4fb2-aeaf-77a267f50a9c
# ╠═a138ae04-a8fb-491c-8d43-41f02878a589
# ╠═d5e00934-dd0b-46dc-8cbc-5328050e9505
# ╠═ea571259-d88a-444b-a8c1-e54e9e6899f5
# ╠═dc65b9cc-70fd-48ed-a085-d02c837becfc
# ╠═4d0359cd-b933-4a86-aae6-645839233cef
# ╠═57750046-e064-4afe-a550-7e0c7f6f3dd0
# ╠═f74dcdeb-b31a-4304-bf3a-25c1c84dafd6
# ╠═8193b197-a4ca-4b5e-b80e-47f9ac38fb5d
# ╠═30ef855c-cb40-4dad-922f-1867f1859001
# ╠═ed691326-3005-4280-aa73-553164d7fa77
# ╠═dae62d82-b345-4868-847d-156f0b0813a0
# ╠═82782605-eb75-4926-9325-dda5ed3dcb7a
# ╠═e5bcfb58-6afa-4cd2-ae9e-907eb4e48961
# ╠═da70e4b9-186b-44e1-a340-46cd827334e5
# ╠═0c9d20bd-5790-4b39-a52d-eff26b8b669e
# ╠═fdac1904-ecb6-43d7-8216-8a332b3034a9
# ╠═2226c541-f4c8-4e14-9e71-f93be025ab60
# ╠═dc46f88d-8f45-4cdf-9681-48e89dcd5eba
# ╠═e41c45d6-4bc7-4fee-af1e-81df3113cd63
# ╠═ea73a960-21e2-42e5-b309-96a2b1ec6338
# ╠═5867bf29-1ff5-4ccd-bb4c-c8a31eb2e0f1
# ╠═438639d2-6d45-4806-a61f-5dca0194d497
# ╠═040e6ae9-2b85-4cd2-9426-650d01afc157
# ╠═71adbe16-d575-4179-ba67-829f5a81071a
# ╠═c22da381-5e5a-41b1-948b-28b29c9d324c
# ╟─c58331c5-460f-40de-81e7-ed66628dc0ce
# ╟─8f804d9b-88b0-4747-913b-aa20e4308858
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
