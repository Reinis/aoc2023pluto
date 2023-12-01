### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ ad437f9c-0911-473d-b1dd-f9ca666dba32
using Test

# ╔═╡ be8e9756-46db-4bed-9f50-20e2e5c19f71
md"
# AoC 2023

## Day 1
"

# ╔═╡ 56885ea8-9080-11ee-218b-73671f082585
e1 = "
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"

# ╔═╡ 2a1f6eee-21ee-448c-a7c0-a3a2e532baff
e2 = "
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"

# ╔═╡ 090becc9-6add-492e-aa46-4db9eb6562e4
function getNumber(line, regex)
	first = missing
	last = missing
	for m in eachmatch(regex, line, overlap = true)
		char = replace(m.match, "one"=>1, "two"=>2, "three"=>3, "four"=>4, "five"=>5, "six"=>6, "seven"=>7, "eight"=>8, "nine"=>9)
		if ismissing(first)
			first = char
		end
		last = char
	end
	return parse(Int8, "$first$last")
end

# ╔═╡ 3351f917-86b1-4d76-86e1-b63f504e1d6a
function p1(text; verbose=0)
	lines = split(strip(text), "\n")
	regex = r"[0-9]"
	numbers = []
	for line in lines
		push!(numbers, getNumber(line, regex))
	end
	0 < verbose && println(numbers)
	return sum(numbers)
end

# ╔═╡ bc13c9c9-5288-4fad-baf3-ae086db9b316
p1(e1; verbose=1)

# ╔═╡ 2d56f9a8-d7f9-479b-a6cb-4e5bfc4d207a
function p2(text; verbose=0)
	lines = split(strip(text), "\n")
	regex = r"[0-9]|one|two|three|four|five|six|seven|eight|nine"
	numbers = []
	for line in lines
		push!(numbers, getNumber(line, regex))
	end
	0 < verbose && println(numbers)
	return sum(numbers)
end

# ╔═╡ 8f2f5e74-dfd5-4fab-b372-fd21c526db06
p2(e2; verbose=1)

# ╔═╡ 43ad24ef-1b12-4f1b-8a82-9026d2d4542d
inp = open(joinpath(@__DIR__, "data", "input01"), "r") do f
	read(f, String)
end

# ╔═╡ f9fd95d9-a222-4f7e-97c3-fb6389daa59a
p1(inp)

# ╔═╡ f58d7f54-df30-4c58-bf21-5b5280363ea2
p2(inp)

# ╔═╡ 9817a74d-198b-4c0e-aa6c-212186b614e4
begin
	@testset verbose = true "Part 1" begin
		@test 142 == p1(e1)
		@test 54338 == p1(inp)
	end
	@testset "Part 2" begin
		@test 281 == p2(e2)
		@test 53389 == p2(inp)
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
# ╟─be8e9756-46db-4bed-9f50-20e2e5c19f71
# ╠═56885ea8-9080-11ee-218b-73671f082585
# ╠═bc13c9c9-5288-4fad-baf3-ae086db9b316
# ╠═f9fd95d9-a222-4f7e-97c3-fb6389daa59a
# ╠═3351f917-86b1-4d76-86e1-b63f504e1d6a
# ╠═2a1f6eee-21ee-448c-a7c0-a3a2e532baff
# ╠═8f2f5e74-dfd5-4fab-b372-fd21c526db06
# ╠═f58d7f54-df30-4c58-bf21-5b5280363ea2
# ╠═2d56f9a8-d7f9-479b-a6cb-4e5bfc4d207a
# ╠═090becc9-6add-492e-aa46-4db9eb6562e4
# ╠═9817a74d-198b-4c0e-aa6c-212186b614e4
# ╠═43ad24ef-1b12-4f1b-8a82-9026d2d4542d
# ╟─ad437f9c-0911-473d-b1dd-f9ca666dba32
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
