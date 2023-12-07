### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 4d868f49-b9bc-4878-af84-7a4983b569ea
using Test

# ╔═╡ cc03839a-94c4-11ee-15ab-e7c919528154
md"
# AoC 2023
## Day 7
"

# ╔═╡ 73dd5ebe-49e8-4faa-aa8b-712d5daf69d1
e1 = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""

# ╔═╡ 24256c70-f019-4e9a-abfb-be15f6eb9284
function rank(numbers)
	n = length(numbers)
	if n == 1
		return 7
	end
	if n == 2
		if numbers[1] == 1
			return 6
		else
			return 5
		end
	end
	if n == 3
		if numbers[2] == 1
			return 4
		else
			return 3
		end
	end
	if n == 4
		return 2
	end
	return 1
end

# ╔═╡ 3b936411-6a07-44f1-9f99-2d8350dea2cd
function getRank(hand)
	counts = Dict()
	for card in hand
		if haskey(counts, card)
			counts[card] += 1
		else
			counts[card] = 1
		end
	end
	numbers = collect(values(counts))
	sort!(numbers)
	rank(numbers)
end

# ╔═╡ f78caf47-d831-4aee-a56d-b034f3af045f
function getRank2(hand)
	counts = Dict()
	js = 0
	for card in hand
		if card == 'J'
			js += 1
		elseif haskey(counts, card)
			counts[card] += 1
		else
			counts[card] = 1
		end
	end
	if js == 5
		return 7
	end
	numbers = collect(values(counts))
	sort!(numbers)
	numbers[end] += js
	rank(numbers)
end

# ╔═╡ 15eadd9f-3843-4022-817a-1d2593dc18fe
function getStrength(card)
	cards = Dict('2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9, 'T'=>10, 'J'=>11, 'Q'=>12, 'K'=>13, 'A'=>14)
	return cards[card]
end

# ╔═╡ be7a0fd3-7317-489f-b70a-ba24d8dd9e59
function isLessHand(a, b)
	x = getRank(a)
	y = getRank(b)
	if x != y
		return x < y
	end
	for (i,j) in zip(a, b)
		m = getStrength(i)
		n = getStrength(j)
		if m != n
			return m < n
		end
	end
end

# ╔═╡ 824d4f3f-e8a8-47a7-85d5-2e401c815e42
function getStrength2(card)
	cards = Dict('2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9, 'T'=>10, 'J'=>1, 'Q'=>12, 'K'=>13, 'A'=>14)
	return cards[card]
end

# ╔═╡ f91e1da8-37b2-47fa-8e3c-94295933926a
function isLessHand2(a, b)
	x = getRank2(a)
	y = getRank2(b)
	if x != y
		return x < y
	end
	for (i,j) in zip(a, b)
		m = getStrength2(i)
		n = getStrength2(j)
		if m != n
			return m < n
		end
	end
end

# ╔═╡ 0545fd69-4930-416f-aa00-a69b62f4bbcb
function getData(text)
	lines = split(text, "\n")
	lines = split.(lines, " ")
	return map(x -> x[1] => parse(Int64, x[2]), lines)
end

# ╔═╡ c78fc22b-e937-420a-ab72-68d4f7b8a8ed
function p1(text; verbose=0)
	hands = getData(strip(text))
	sort!(hands; lt=isLessHand, by=x->x.first)
	result = 0
	for (i,p) in enumerate(hands)
		0 < verbose && println((i,p))
		result += i * p.second
	end
	return result
end

# ╔═╡ f27be85b-4bc2-4860-9d07-d4db1416588c
p1(e1; verbose=1)

# ╔═╡ 460a957e-d535-4214-9cd9-8ffc60b02627
function p2(text; verbose=0)
	hands = getData(strip(text))
	sort!(hands; lt=isLessHand2, by=x->x.first)
	result = 0
	for (i,p) in enumerate(hands)
		0 < verbose && println((i,p))
		result += i * p.second
	end
	return result
end

# ╔═╡ 513ca29a-3c65-40ae-acc5-82ea5b6fa864
p2(e1; verbose=1)

# ╔═╡ 272ff4b4-d749-406c-933f-965183d165d0
inp = open(joinpath(@__DIR__, "data", "input07"), "r") do f
	read(f, String)
end

# ╔═╡ e51165fd-2943-4f86-9506-83dfdde5b15f
p1(inp)

# ╔═╡ ad22b459-a2fc-4a1a-9492-d060a27537d0
p2(inp)

# ╔═╡ 65da2cee-cd0d-4cca-87a6-81a50b7e7487
begin
	@testset "Part 1" begin
		@test 6440 == p1(e1)
		@test 253954294 == p1(inp)
	end
	@testset "Part 2" begin
		@test 5905 == p2(e1)
		@test 254837398 == p2(inp)
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
# ╟─cc03839a-94c4-11ee-15ab-e7c919528154
# ╠═73dd5ebe-49e8-4faa-aa8b-712d5daf69d1
# ╠═f27be85b-4bc2-4860-9d07-d4db1416588c
# ╠═e51165fd-2943-4f86-9506-83dfdde5b15f
# ╠═c78fc22b-e937-420a-ab72-68d4f7b8a8ed
# ╠═513ca29a-3c65-40ae-acc5-82ea5b6fa864
# ╠═ad22b459-a2fc-4a1a-9492-d060a27537d0
# ╠═460a957e-d535-4214-9cd9-8ffc60b02627
# ╠═be7a0fd3-7317-489f-b70a-ba24d8dd9e59
# ╠═f91e1da8-37b2-47fa-8e3c-94295933926a
# ╠═3b936411-6a07-44f1-9f99-2d8350dea2cd
# ╠═f78caf47-d831-4aee-a56d-b034f3af045f
# ╠═24256c70-f019-4e9a-abfb-be15f6eb9284
# ╠═15eadd9f-3843-4022-817a-1d2593dc18fe
# ╠═824d4f3f-e8a8-47a7-85d5-2e401c815e42
# ╠═0545fd69-4930-416f-aa00-a69b62f4bbcb
# ╠═65da2cee-cd0d-4cca-87a6-81a50b7e7487
# ╟─272ff4b4-d749-406c-933f-965183d165d0
# ╟─4d868f49-b9bc-4878-af84-7a4983b569ea
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
