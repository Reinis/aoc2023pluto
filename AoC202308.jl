### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 7760b342-e06c-4823-a3a0-38614a7d5d41
using Test

# ╔═╡ 07757c24-95f6-11ee-22df-5d8c909b257b
md"
# AoC 2023
## Day 8
"

# ╔═╡ 44f7b382-095b-4eac-935f-5e8d274c3288
e1 = """
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
"""

# ╔═╡ 21e9e6f7-e77f-488c-8f6e-b20c94f63f86
e2 = """
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
"""

# ╔═╡ bc3eab53-21f1-4b27-84a3-b5744768a3ce
function countSteps(directions, network, current, cond; verbose=0)
	n = length(directions)
	i = 0
	while cond(current)
		i += 1
		j = (i-1)%n+1
		d = Symbol(directions[j])
		current = network[current][d]
		if 0 < verbose
			println("$i $j $d -> $current")
		end
		# if i > 10
		# 	break
		# end
	end
	return i
end

# ╔═╡ 47a5c009-08b3-42a3-88a7-f0e78fcc71ae
e3 = """
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
"""

# ╔═╡ a894b691-47f6-4a73-bd59-cf7a6f81b344
function getCurrents(net)
	filter(x->x[3] == 'A', keys(net)) |> collect
end

# ╔═╡ 2a7b54ce-6a4f-4126-81ca-fc781af92a94
function parseNetwork(text)
	lines = split(text, "\n")
	network = Dict()
	for line in lines
		L = line[8:10]
		R = line[13:15]
		setindex!(network, (; L, R), line[1:3])
	end
	return network
end

# ╔═╡ 3405032f-759b-4b1f-8f8a-25185f722af1
function getData(text)
	directions, network = split(text, "\n\n")
	network = parseNetwork(network)
	return directions, network
end

# ╔═╡ 0265ccfa-3b42-421a-8a62-57f2724e77a8
function p1(text; verbose=0)
	directions, network = getData(strip(text))
	if 1 < verbose
		display(directions)
		display(network)
	end
	current = "AAA"
	stop = "ZZZ"
	return countSteps(directions, network, current, x->x != stop; verbose)
end

# ╔═╡ 612a84ca-be08-405a-8acc-9d498ea83e2f
p1(e1; verbose=2)

# ╔═╡ 4ad6e8d7-ffaa-444c-b1fc-a3f8e21fa232
p1(e2; verbose=2)

# ╔═╡ 900cef51-7483-4cde-bc57-84a784b9b09f
function p2(text; verbose=0)
	directions, network = getData(strip(text))
	if 1 < verbose
		display(directions)
		display(network)
	end
	n = length(directions)
	currents = getCurrents(network)
	cond = x->x[3] != 'Z'
	steps = []
	for c in currents
		push!(steps, countSteps(directions, network, c, cond; verbose))
	end
	return lcm(steps...)
end

# ╔═╡ d815d440-7990-4d75-9689-5deee12e79e0
p2(e3; verbose=2)

# ╔═╡ 78da2103-1255-4879-b343-1ee3de5aa0b6
inp = open(joinpath(@__DIR__, "data", "input08"), "r") do f
	read(f, String)
end

# ╔═╡ acae7b67-8807-45bd-a29a-8fcb6f078a62
p1(inp; verbose=0)

# ╔═╡ 89a96c0c-a2ee-4b67-bbcb-2d78adf7b05f
p2(inp)

# ╔═╡ e1fdfe46-f51a-4812-8507-b5cbe125ad1a
begin
	@testset "Part 1" begin
		@test 2 == p1(e1)
		@test 6 == p1(e2)
		@test 18157 == p1(inp)
	end
	@testset "Part 2" begin
		@test 6 == p2(e3)
		@test 14299763833181 == p2(inp)
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
# ╟─07757c24-95f6-11ee-22df-5d8c909b257b
# ╠═44f7b382-095b-4eac-935f-5e8d274c3288
# ╠═21e9e6f7-e77f-488c-8f6e-b20c94f63f86
# ╠═612a84ca-be08-405a-8acc-9d498ea83e2f
# ╠═4ad6e8d7-ffaa-444c-b1fc-a3f8e21fa232
# ╠═acae7b67-8807-45bd-a29a-8fcb6f078a62
# ╠═0265ccfa-3b42-421a-8a62-57f2724e77a8
# ╠═bc3eab53-21f1-4b27-84a3-b5744768a3ce
# ╠═47a5c009-08b3-42a3-88a7-f0e78fcc71ae
# ╠═d815d440-7990-4d75-9689-5deee12e79e0
# ╠═89a96c0c-a2ee-4b67-bbcb-2d78adf7b05f
# ╠═900cef51-7483-4cde-bc57-84a784b9b09f
# ╠═a894b691-47f6-4a73-bd59-cf7a6f81b344
# ╠═3405032f-759b-4b1f-8f8a-25185f722af1
# ╠═2a7b54ce-6a4f-4126-81ca-fc781af92a94
# ╠═e1fdfe46-f51a-4812-8507-b5cbe125ad1a
# ╟─78da2103-1255-4879-b343-1ee3de5aa0b6
# ╟─7760b342-e06c-4823-a3a0-38614a7d5d41
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
