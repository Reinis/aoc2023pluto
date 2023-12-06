### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ b76e7026-d39d-41b7-89fc-46e1d06cf292
using Test

# ╔═╡ 61410100-9333-11ee-30d6-9d60dc2b5fe8
md"
# AoC 2023
## Day 5
"

# ╔═╡ 0506924a-6fb7-44a1-9bc0-ccd66c8b2c16
e1 = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""

# ╔═╡ 463cd586-748b-4474-97c2-f709d60f39ad
function rangeToSingle(seeds)
	result = []
	for (a,b) in seeds
		c = b-a+1
		push!(result, (a,a), (c,c))
	end
	return result
end

# ╔═╡ c6bcdce6-33d4-4f8e-98ae-1890fe99694c
function scatter(seeds, range)
	moved = []
	stayed = []
	n = length(seeds)
	source = range[1:2]
	dest = range[3:4]
	d = dest[1]-source[1]
	p = source[1]
	q = source[2]
	for (a,b) in seeds
		if a <= q && b >= p
			# overlap
			if a >= p && b <= q
				# inside
				push!(moved, (a+d, b+d))
			else
				# split
				if a < p
					push!(stayed, (a, p-1))
				end
				if b > q
					push!(stayed, (q+1, b))
				end
				push!(moved, (max(a, p)+d, min(b, q)+d))
			end
		else
			push!(stayed, (a, b))
		end
	end
	return stayed, moved
end

# ╔═╡ a62e6cad-e2eb-46a6-9f74-cb4baf20c373
function translate(n, ranges)
	for range in ranges
		if range[2] <= n <= range[2]+range[3]-1
			return n-range[2]+range[1]
		end
	end
	return n
end

# ╔═╡ e52aed8d-848c-4f04-8510-22b1ca9e2816
function getLocation(seed, maps)
	n = seed
	for map in maps
		n = translate(n, map)
	end
	return n
end

# ╔═╡ 45a493a4-85b5-4df4-8982-34ecbeebe2f1
function getMinLocation(a, b, maps)
	location = missing
	for seed in a:a+b-1
		l = getLocation(seed, maps)
		if ismissing(location) || location > l
			location = l
		end
	end
	if ismissing(location)
		println(a, b, location)
	end
	return location
end

# ╔═╡ 627522e5-217e-45a2-914d-1d6de0d3f26b
function getLocations(seeds, maps)
	locations = []
	for seed in seeds
		location = getLocation(seed, maps)
		push!(locations, location)
	end
	return locations
end

# ╔═╡ 583d03fc-bba3-4c32-aeeb-a1d104841c38
function seedsToRange(seeds)
	n = length(seeds)
	ranges = []
	for i in 1:2:n
		push!(ranges, (seeds[i], seeds[i]+seeds[i+1]-1))
	end
	return ranges
end

# ╔═╡ 9265f6c5-cbb9-49df-8f4b-0d714976c4d2
function getSeeds(line)
	line = replace(line, "seeds: "=>"")
	seeds = split(line, " ")
	return parse.(Int64, seeds)
end

# ╔═╡ 8e859206-f11e-4173-8856-6a89477bcb22
function parseBlock(block)
	lines = split(block, "\n")
	header = replace(lines[1], " map:"=>"")
	source, dest = split(header, "-to-")
	n = length(lines)
	ranges = []
	for line in lines[2:n]
		range = parse.(Int64, split(line, " "))
		push!(ranges, range)
	end
	return source, dest, ranges
end

# ╔═╡ 3beed4d7-95ab-4f9c-a48b-7037634281d9
function getMaps(blocks)
	maps = []
	for block in blocks
		source, dest, map = parseBlock(block)
		push!(maps, map)
	end
	return maps
end

# ╔═╡ 3a1ce231-58f3-45ae-a56a-a5299ea76e2f
function getData(text)
	blocks = split(text, "\n\n")
	n = length(blocks)
	seeds = getSeeds(blocks[1])
	maps = getMaps(blocks[2:n])
	return seeds, maps
end

# ╔═╡ 597a5076-ca70-4437-b2c7-b1e93755163f
function p1(text; verbose=0)
	seeds, maps = getData(strip(text))
	locations = getLocations(seeds, maps)
	if 0 < verbose
		println(locations)
	end
	return min(locations...)
end

# ╔═╡ b874a33c-4e78-4611-af87-8dc36524add0
p1(e1; verbose=1)

# ╔═╡ 09b634bb-3192-4e68-a51a-e9913b7aacaa
function getMaps2(blocks)
	maps = []
	for block in blocks
		source, dest, ranges = parseBlock(block)
		map = []
		for range in ranges
			d = range[3]-1
			a = range[2]
			b = range[1]
			push!(map, [a, a+d, b, b+d])
		end
		push!(maps, map)
	end
	return maps
end

# ╔═╡ 5b8319d4-1a6e-4f26-8091-145ab435316b
function getData2(text)
	blocks = split(text, "\n\n")
	n = length(blocks)
	seeds = getSeeds(blocks[1])
	seeds = seedsToRange(seeds)
	maps = getMaps2(blocks[2:n])
	return seeds, maps
end

# ╔═╡ 137470b6-d87b-4cf2-ab52-a8d56f032dd9
function p11(text; verbose=0)
	seeds, maps = getData2(strip(text))
	seeds = rangeToSingle(seeds)
	# println(seeds)
	for map in maps
		tmp = []
		for range in map
			seeds, moved = scatter(seeds, range)
			push!(tmp, moved...)
			# println(range, seeds)
			# display(['r'=>range,'s'=>seeds,'m'=>moved])
		end
		push!(tmp, seeds...)
		seeds = unique(tmp)
		sort!(seeds)
		# println(seeds)
		# println("---")
	end
	sort!(seeds)
	0 < verbose && println(seeds)
	return seeds[1][1]
end

# ╔═╡ bff9cb38-b96f-47c7-ae5b-86fac808e096
p11(e1; verbose=1)

# ╔═╡ d5bcdfc1-fdc5-4b2c-be22-12803d2e23e7
function p2(text; verbose=0)
	seeds, maps = getData2(strip(text))
	if 0 < verbose
		println(seeds)
	end
	for map in maps
		tmp = []
		for range in map
			seeds, moved = scatter(seeds, range)
			push!(tmp, moved...)
			# println(range, seeds)
			# display(['r'=>range,'s'=>seeds,'m'=>moved])
		end
		push!(tmp, seeds...)
		seeds = unique(tmp)
		sort!(seeds)
		if 1 < verbose
			println(seeds)
			println("---")
		end
	end
	sort!(seeds)
	if 0 < verbose
		println(seeds)
	end
	return seeds[1][1]
end

# ╔═╡ 7f865a74-7e64-435c-bb85-4f5028b89a38
p2(e1; verbose=1)

# ╔═╡ 56802b53-312d-4027-809f-a27207a3aeaa
inp = open(joinpath(@__DIR__, "data", "input05"), "r") do f
	read(f, String)
end

# ╔═╡ f7e5afbc-86bb-4011-a479-05cb1b06dcd2
p1(inp; verbose=1)

# ╔═╡ ff6db598-3148-46b1-a41a-771d92e3dda2
p2(inp; verbose=0)

# ╔═╡ bd616f11-d364-4fbc-85d9-f6eb7d2264ab
getData2(strip(inp))

# ╔═╡ 8fc0db47-899c-48a2-8023-2fe99a9d1cbc
begin
	@testset "Part 1" begin
		@test 35 == p1(e1)
		@test 174137457 == p1(inp)
		@test 35 == p11(e1)
		@test 174137457 == p11(inp)
	end
	@testset "Part 2" begin
		@test 46 == p2(e1)
		@test 1493866 == p2(inp)
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
# ╟─61410100-9333-11ee-30d6-9d60dc2b5fe8
# ╠═0506924a-6fb7-44a1-9bc0-ccd66c8b2c16
# ╠═b874a33c-4e78-4611-af87-8dc36524add0
# ╠═f7e5afbc-86bb-4011-a479-05cb1b06dcd2
# ╠═597a5076-ca70-4437-b2c7-b1e93755163f
# ╠═bff9cb38-b96f-47c7-ae5b-86fac808e096
# ╠═137470b6-d87b-4cf2-ab52-a8d56f032dd9
# ╠═463cd586-748b-4474-97c2-f709d60f39ad
# ╠═7f865a74-7e64-435c-bb85-4f5028b89a38
# ╠═ff6db598-3148-46b1-a41a-771d92e3dda2
# ╠═bd616f11-d364-4fbc-85d9-f6eb7d2264ab
# ╠═d5bcdfc1-fdc5-4b2c-be22-12803d2e23e7
# ╠═c6bcdce6-33d4-4f8e-98ae-1890fe99694c
# ╠═45a493a4-85b5-4df4-8982-34ecbeebe2f1
# ╠═627522e5-217e-45a2-914d-1d6de0d3f26b
# ╠═e52aed8d-848c-4f04-8510-22b1ca9e2816
# ╠═a62e6cad-e2eb-46a6-9f74-cb4baf20c373
# ╠═3a1ce231-58f3-45ae-a56a-a5299ea76e2f
# ╠═5b8319d4-1a6e-4f26-8091-145ab435316b
# ╠═583d03fc-bba3-4c32-aeeb-a1d104841c38
# ╠═9265f6c5-cbb9-49df-8f4b-0d714976c4d2
# ╠═3beed4d7-95ab-4f9c-a48b-7037634281d9
# ╠═09b634bb-3192-4e68-a51a-e9913b7aacaa
# ╠═8e859206-f11e-4173-8856-6a89477bcb22
# ╠═8fc0db47-899c-48a2-8023-2fe99a9d1cbc
# ╟─56802b53-312d-4027-809f-a27207a3aeaa
# ╟─b76e7026-d39d-41b7-89fc-46e1d06cf292
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
