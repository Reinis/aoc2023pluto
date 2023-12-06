### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 5b4f0687-cadb-457d-a1d9-40b1e1236ef1
using Test

# ╔═╡ 8da29666-9471-11ee-2e57-e5558f0dd919
md"
# AoC 2023
## Day 6
"

# ╔═╡ d0256544-53df-4b99-805c-1078473f5fc8
e1 = """
Time:      7  15   30
Distance:  9  40  200
"""

# ╔═╡ 23fbbea0-cba7-4105-82f6-dc7659e32e68
function countWins(record, time)
	ds = []
	for i in 0:time
		push!(ds, i*(time-i))
	end
	wins = filter(x -> x > record, ds)
	return length(wins)
end

# ╔═╡ fe8db3fc-f7f6-46a2-acf2-fac46c03e983
function getData(text)
	lines = split(text, "\n")
	lines = replace.(lines, r"Time:\s+"=>"", r"Distance:\s+"=>"", r"\s+"=>" ")
	splitSpace = x -> split(x, " ")
	parseInt = x -> parse.(Int64, x)
	numbers = lines .|> splitSpace .|> parseInt
	return numbers
end

# ╔═╡ 8880b311-11bf-4e83-a215-2eb3df36e690
function p1(text; verbose=0)
	times, distances = getData(strip(text))
	wins = []
	n = length(times)
	for i in 1:n
		win = countWins(distances[i], times[i])
		push!(wins, win)
	end
	if 0 < verbose
		println(wins)
	end
	return prod(wins)
end

# ╔═╡ 776fc963-94ef-4557-ba3c-2164be651ebc
p1(e1; verbose=1)

# ╔═╡ fe434039-f63e-4829-a19d-eb692cc1f53a
function getData2(text)
	lines = split(text, "\n")
	lines = replace.(lines, r"Time:\s+"=>"", r"Distance:\s+"=>"", r"\s+"=>"")
	parseInt = x -> parse.(Int64, x)
	numbers = lines |> parseInt
	return numbers
end

# ╔═╡ 7833939b-2780-447b-9cc6-c8174c4e89ea
function p2(text; verbose=0)
	time, distance = getData2(strip(text))
	if 0 < verbose
		println((time, distance))
	end
	c = 0
	for i in 0:time
		if i*(time-i) > distance
			c += 1
		end
	end
	return c
end

# ╔═╡ 812d0509-4104-4ad6-b8cc-639dac6725b5
p2(e1; verbose=1)

# ╔═╡ a124c9c3-4c49-4644-b12d-ccfade6546ae
inp = open(joinpath(@__DIR__, "data", "input06"), "r") do f
	read(f, String)
end

# ╔═╡ 2335c92f-12a9-47ab-9130-6cabf51660dc
p1(inp; verbose=1)

# ╔═╡ cc09094d-7b08-44b3-a740-6f7ff2b5a024
p2(inp; verbose=1)

# ╔═╡ 73b588f1-c403-471b-874a-23a96044bb32
begin
	@testset "Part 1" begin
		@test 288 == p1(e1)
		@test 1155175 == p1(inp)
	end
	@testset "Part 2" begin
		@test 71503 == p2(e1)
		@test 35961505 == p2(inp)
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
# ╟─8da29666-9471-11ee-2e57-e5558f0dd919
# ╠═d0256544-53df-4b99-805c-1078473f5fc8
# ╠═776fc963-94ef-4557-ba3c-2164be651ebc
# ╠═2335c92f-12a9-47ab-9130-6cabf51660dc
# ╠═8880b311-11bf-4e83-a215-2eb3df36e690
# ╠═812d0509-4104-4ad6-b8cc-639dac6725b5
# ╠═cc09094d-7b08-44b3-a740-6f7ff2b5a024
# ╠═7833939b-2780-447b-9cc6-c8174c4e89ea
# ╠═23fbbea0-cba7-4105-82f6-dc7659e32e68
# ╠═fe8db3fc-f7f6-46a2-acf2-fac46c03e983
# ╠═fe434039-f63e-4829-a19d-eb692cc1f53a
# ╠═73b588f1-c403-471b-874a-23a96044bb32
# ╟─a124c9c3-4c49-4644-b12d-ccfade6546ae
# ╟─5b4f0687-cadb-457d-a1d9-40b1e1236ef1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
