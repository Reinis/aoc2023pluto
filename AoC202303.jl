### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ af316076-d537-4438-a098-65ef80ca727a
using Test

# ╔═╡ a5e6fbaa-91b4-11ee-2ed5-611028aefd2e
md"
# AoC 2023
## Day 3
"

# ╔═╡ 9026e82c-eecf-48ae-b873-f6a6fac07ebc
e1 = raw"
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"

# ╔═╡ 9e8fb363-685e-4c36-9a7e-33b69eaa79d6
function getGears(data)
	gears = []
	h = length(data)
	w = length(data[1])
	for i in 1:h
		for j in 1:w
			if data[i][j] == '*'
				push!(gears, (i,j))
			end
		end
	end
	return gears
end

# ╔═╡ c75ce832-1d26-43df-9428-b6397c6b9b36
function getSymbols(data)
	symbols = []
	h = length(data)
	w = length(data[1])
	for i in 1:h
		for j in 1:w
			if !isnumeric(data[i][j]) && data[i][j] != '.'
				push!(symbols, (i,j))
			end
		end
	end
	return symbols
end

# ╔═╡ ce819d3f-cfca-4b3a-8262-2eb3e21e52cc
function getFirst(data, i, j)
	for x in j:-1:1
		if !isnumeric(data[i][x])
			return x+1
		end
	end
	return 1
end

# ╔═╡ 0ab7faf9-e037-4b38-a5be-4ade65503d92
function getLast(data, i, j)
	width = length(data[1])
	for x in j:width
		if !isnumeric(data[i][x])
			return x-1
		end
	end
	return width
end

# ╔═╡ bf62140a-f16c-42fe-bb7d-4e63bd4fab58
function getPair(data, i, j)
	first = getFirst(data, i, j)
	last = getLast(data, i, j)
	number = parse(Int64, data[i][first:last])
	return (i,first), number
end

# ╔═╡ 7d4541bf-dd52-4dc2-a620-8e2fc0a3052c
function getPairs(data, i, j)
	xmin = max(j-1, 1)
	xmax = min(j+1, length(data[1]))
	ymin = max(i-1, 1)
	ymax = min(i+1, length(data))
	pairs = []
	for y in ymin:ymax
		for x in xmin:xmax
			if isnumeric(data[y][x])
				pair = getPair(data, y, x)
				push!(pairs, pair)
			end
		end
	end
	pairs = unique(pairs)
	return pairs
end

# ╔═╡ ac71be1c-1804-4134-ab0d-e40c8c3d4059
function getRatios(data, gears; verbose=0)
	ratios = []
	for (i,j) in gears
		pairs = getPairs(data, i, j)
		if length(pairs) != 2
			continue
		end
		if 1 < verbose
			println(pairs)
		end
		push!(ratios, pairs[1][2] * pairs[2][2])
	end
	return ratios
end

# ╔═╡ 4d2225ba-a916-44bb-a24b-59d0315615f9
function getGearRatios(data; verbose=0)
	gears = getGears(data)
	return getRatios(data, gears; verbose)
end

# ╔═╡ a19c3aa4-d81f-4a1c-afba-752f328b9ccb
function getNumbers(data, ns)
	pairs = []
	for (i,j) in ns
		for pair in getPairs(data, i, j)
			push!(pairs, pair)
		end
	end
	pairs = unique(pairs)
	return pairs
end

# ╔═╡ ebd7354b-a361-4169-9510-2e5b93e0ef29
function getAdjacentNumbers(data)
	symbols = getSymbols(data)
	adjacent = getNumbers(data, symbols)
	return map(x -> x[2], adjacent)
end

# ╔═╡ a16a2f85-50a4-4c5c-95dd-163284d772d3
function getData(text)
	lines = split(strip(text), "\n")
	return lines
end

# ╔═╡ bc98befc-608d-4be2-a5b9-ae80fc81504e
function p1(text; verbose=0)
	data = getData(text)
	numbers = getAdjacentNumbers(data)
	if 0 < verbose
		println(numbers)
	end
	return sum(numbers)
end

# ╔═╡ f8ca39c7-9b3d-495d-8cad-12a852b02492
p1(e1; verbose=1)

# ╔═╡ ef36b491-08a3-400e-b55c-511f4e05505b
function p2(text; verbose=0)
	data = getData(text)
	gearRatios = getGearRatios(data; verbose)
	if 0 < verbose
		println(gearRatios)
	end
	return sum(gearRatios)
end

# ╔═╡ 0526f371-b7e0-4366-85da-f7255fb0129d
p2(e1; verbose=1)

# ╔═╡ cdeb45ae-0244-44bd-b505-a05a6f3a5951
inp = open(joinpath(@__DIR__, "data", "input03"), "r") do f
	read(f, String)
end

# ╔═╡ 511e298e-141e-4080-ad69-1bb9ca89f916
p1(inp)

# ╔═╡ e0045143-e05c-4ec0-ac86-1c4e2339679d
p2(inp)

# ╔═╡ e11cd3e0-49a8-4b00-80e3-f0233d851b35
begin
	@testset "Part 1" begin
		@test 4361 == p1(e1)
		@test 498559 == p1(inp)
	end
	@testset "Part 2" begin
		@test 467835 == p2(e1)
		@test 72246648 == p2(inp)
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
# ╟─a5e6fbaa-91b4-11ee-2ed5-611028aefd2e
# ╠═9026e82c-eecf-48ae-b873-f6a6fac07ebc
# ╠═f8ca39c7-9b3d-495d-8cad-12a852b02492
# ╠═511e298e-141e-4080-ad69-1bb9ca89f916
# ╠═bc98befc-608d-4be2-a5b9-ae80fc81504e
# ╠═0526f371-b7e0-4366-85da-f7255fb0129d
# ╠═e0045143-e05c-4ec0-ac86-1c4e2339679d
# ╠═ef36b491-08a3-400e-b55c-511f4e05505b
# ╠═4d2225ba-a916-44bb-a24b-59d0315615f9
# ╠═9e8fb363-685e-4c36-9a7e-33b69eaa79d6
# ╠═ac71be1c-1804-4134-ab0d-e40c8c3d4059
# ╠═ebd7354b-a361-4169-9510-2e5b93e0ef29
# ╠═c75ce832-1d26-43df-9428-b6397c6b9b36
# ╠═a19c3aa4-d81f-4a1c-afba-752f328b9ccb
# ╠═7d4541bf-dd52-4dc2-a620-8e2fc0a3052c
# ╠═bf62140a-f16c-42fe-bb7d-4e63bd4fab58
# ╠═ce819d3f-cfca-4b3a-8262-2eb3e21e52cc
# ╠═0ab7faf9-e037-4b38-a5be-4ade65503d92
# ╠═a16a2f85-50a4-4c5c-95dd-163284d772d3
# ╠═e11cd3e0-49a8-4b00-80e3-f0233d851b35
# ╟─cdeb45ae-0244-44bd-b505-a05a6f3a5951
# ╟─af316076-d537-4438-a098-65ef80ca727a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
