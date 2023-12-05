### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

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

# ╔═╡ a62e6cad-e2eb-46a6-9f74-cb4baf20c373
function translate(n, ranges)
	# display(map.firsnt.second)
	# display(map)
	for range in ranges
		# display(range)
		if range[2] <= n <= range[2]+range[3]-1
			return (n-range[2])+range[1]
		end
	end
	return n
end

# ╔═╡ e52aed8d-848c-4f04-8510-22b1ca9e2816
function getLocation(seed, maps)
	n = seed
	# println("seed $n")
	for map in maps
		n = translate(n, map)
		# println("  $n")
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
		# setindex!(locations, location, "$seed")
		push!(locations, location)
	end
	return locations
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
function p1(text)
	seeds, maps = getData(strip(text))
	locations = getLocations(seeds, maps)
	println(locations)
	return min(locations...)
end

# ╔═╡ b874a33c-4e78-4611-af87-8dc36524add0
p1(e1)

# ╔═╡ d5bcdfc1-fdc5-4b2c-be22-12803d2e23e7
function p2(text)
	seeds, maps = getData(strip(text))
	l = []
	n = length(seeds)
	for i in 1:n
		if 0 == i%2
			continue
		end
		push!(l, getMinLocation(seeds[i], seeds[i+1], maps))
	end
	println(l)
	return min(l...)
end

# ╔═╡ 56802b53-312d-4027-809f-a27207a3aeaa
inp = open(joinpath(@__DIR__, "data", "input05"), "r") do f
	read(f, String)
end

# ╔═╡ f7e5afbc-86bb-4011-a479-05cb1b06dcd2
p1(inp)

# ╔═╡ ff6db598-3148-46b1-a41a-771d92e3dda2
# ╠═╡ disabled = true
#=╠═╡
p2(inp)
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─61410100-9333-11ee-30d6-9d60dc2b5fe8
# ╠═0506924a-6fb7-44a1-9bc0-ccd66c8b2c16
# ╠═b874a33c-4e78-4611-af87-8dc36524add0
# ╠═f7e5afbc-86bb-4011-a479-05cb1b06dcd2
# ╠═597a5076-ca70-4437-b2c7-b1e93755163f
# ╠═ff6db598-3148-46b1-a41a-771d92e3dda2
# ╠═d5bcdfc1-fdc5-4b2c-be22-12803d2e23e7
# ╠═45a493a4-85b5-4df4-8982-34ecbeebe2f1
# ╠═627522e5-217e-45a2-914d-1d6de0d3f26b
# ╠═e52aed8d-848c-4f04-8510-22b1ca9e2816
# ╠═a62e6cad-e2eb-46a6-9f74-cb4baf20c373
# ╠═3a1ce231-58f3-45ae-a56a-a5299ea76e2f
# ╠═9265f6c5-cbb9-49df-8f4b-0d714976c4d2
# ╠═3beed4d7-95ab-4f9c-a48b-7037634281d9
# ╠═8e859206-f11e-4173-8856-6a89477bcb22
# ╟─56802b53-312d-4027-809f-a27207a3aeaa
