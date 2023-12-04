### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 29a27118-62e9-4dcc-b604-d523d8546269
using Test

# ╔═╡ cd66c38c-9262-11ee-162e-3706e92c40f4
md"
# AoC 2023
## Day 4
"

# ╔═╡ 510d84b4-bee1-4eef-ac7e-a0cef3513b21
e1 = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

# ╔═╡ fa3ed00b-fab0-4ed0-b0a5-c4e9e79d4701
function countCards(deck)
	counts = []
	for i in 1:length(deck)
		push!(counts, length(deck[i]))
	end
	return counts
end

# ╔═╡ 9dedf382-a278-42d9-986d-fe3ee626641f
function addCards!(deck, i, count)
	if count < 1
		return
	end
	for k in i+1:i+count
		deck[k] = push!(deck[k], deck[k][1])
	end
end

# ╔═╡ 569d1b33-347b-4491-adbb-bd9e1a793cde
function getPoints(card)
	winning, my = card
	# display(winning)
	# display(my)
	points = 0
	for number in winning
		if number in my
			points = 0 == points ? 1 : points * 2
		end
	end
	return points
end

# ╔═╡ ef402574-1c85-4087-a5c9-b51f2773b375
function countMatching(card)
	winning, my = card
	count = 0
	for number in winning
		if number in my
			count = count + 1
		end
	end
	return count
end

# ╔═╡ 71570825-a82c-4d2d-847f-b07c30781eb6
function toDict(cards)
	return Dict(enumerate(map(x->[countMatching(x)], cards)))
end

# ╔═╡ 875356fc-44ce-4878-87a4-e4fef492303d
function getCards(text)
	lines = split(strip(text), "\n")
	splitSpace = x -> split.(x, " ")
	splitPipe = x -> split(x, " | ")
	stripHead = x -> replace(x, r"Card\s+\d+:\s+"=>"")
	normalizeSpace = x -> replace(x, r"\s+"=>" ")
	cards = lines .|> stripHead .|> normalizeSpace .|> splitPipe .|> splitSpace
	# display(cards)
	return cards
end

# ╔═╡ 3c74f529-a183-476d-baf6-6450ce4d3887
function p1(text; verbose=0)
	cards = getCards(text)
	points = []
	for card in cards
		push!(points, getPoints(card))
	end
	if 0 < verbose
		println(points)
	end
	return sum(points)
end

# ╔═╡ b6e09200-2203-41f1-aad0-3eef1df90e7f
p1(e1; verbose=1)

# ╔═╡ 1d57e303-b4a8-4f33-b7c3-6b80252da9db
function p2(text; verbose=0)
	cards = getCards(text)
	n = length(cards)
	deck = toDict(cards)
	# display(deck)
	for i in 1:n
		for matching in deck[i]
			addCards!(deck, i, matching)
		end
	end
	# display(deck)
	counts = countCards(deck)
	if 0 < verbose
		println(counts)
	end
	return sum(counts)
end

# ╔═╡ c7bee4f7-72e7-428b-b768-1739ef3e448a
p2(e1; verbose=1)

# ╔═╡ 0ba6b61c-ad65-4716-8859-ce0d17bed064
inp = open(joinpath(@__DIR__, "data", "input04"), "r") do f
	read(f, String)
end

# ╔═╡ 8dd0b80d-b651-4858-a5be-3126c5e042ac
p1(inp)

# ╔═╡ 8a16680a-373c-442a-9ca3-654cdef5299f
p2(inp)

# ╔═╡ 79c2a693-9636-410a-95a5-27c3b22164a3
begin
	@testset "Part 1" begin
		@test 13 == p1(e1)
		@test 25174 == p1(inp)
	end
	@testset "Part 2" begin
		@test 30 == p2(e1)
		@test 6420979 == p2(inp)
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
# ╟─cd66c38c-9262-11ee-162e-3706e92c40f4
# ╠═510d84b4-bee1-4eef-ac7e-a0cef3513b21
# ╠═b6e09200-2203-41f1-aad0-3eef1df90e7f
# ╠═8dd0b80d-b651-4858-a5be-3126c5e042ac
# ╠═3c74f529-a183-476d-baf6-6450ce4d3887
# ╠═c7bee4f7-72e7-428b-b768-1739ef3e448a
# ╠═8a16680a-373c-442a-9ca3-654cdef5299f
# ╠═1d57e303-b4a8-4f33-b7c3-6b80252da9db
# ╠═fa3ed00b-fab0-4ed0-b0a5-c4e9e79d4701
# ╠═71570825-a82c-4d2d-847f-b07c30781eb6
# ╠═9dedf382-a278-42d9-986d-fe3ee626641f
# ╠═569d1b33-347b-4491-adbb-bd9e1a793cde
# ╠═ef402574-1c85-4087-a5c9-b51f2773b375
# ╠═875356fc-44ce-4878-87a4-e4fef492303d
# ╠═79c2a693-9636-410a-95a5-27c3b22164a3
# ╟─0ba6b61c-ad65-4716-8859-ce0d17bed064
# ╟─29a27118-62e9-4dcc-b604-d523d8546269
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
