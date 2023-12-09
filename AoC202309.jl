### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ fc5cb01c-e1a5-4d98-81c4-3fa5b48d8581
using Test

# ╔═╡ b890b8a2-9689-11ee-3f8b-f329feed1c73
md"
# AoC 2023
## Day 9
"

# ╔═╡ d700221d-30df-4e95-9478-b464d12f4e1a
e1 = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""

# ╔═╡ 392f6612-e12d-40ce-bfec-6f8c9fe2fdd1
function diff(seq)
	ns = []
	while !all(==(0), seq)
		push!(ns, seq)
		seq = [seq[i]-seq[i-1] for i in 2:length(seq)]
	end
	ns
end

# ╔═╡ ff071327-d025-444c-bf19-da9e0bc54311
function extrapolate(seq)
	diff(seq) .|> last |> sum
end

# ╔═╡ aa164608-7f12-4f84-b2ff-6ee2330da572
function extrapolate2(seq)
	diff(seq) .|> first |> x->foldr(-, x)
end

# ╔═╡ 08df431d-08ef-427c-8651-3960c21cc774
function getData(text)
	lines = split(text, "\n")
	split.(lines, " ") .|> x->parse.(Int, x)
end

# ╔═╡ 75fcc888-de8d-4533-b0f2-d13f3bf808ad
function p1(text; verbose=0)
	data = getData(strip(text))
	numbers = extrapolate.(data)
	if 0 < verbose
		println(numbers)
	end
	sum(numbers)
end

# ╔═╡ 0bfa72de-ab60-4b1d-acbe-b2095f80c4b0
p1(e1; verbose=1)

# ╔═╡ e3c456f1-2a46-4087-a13d-4f12a1547d0d
function p2(text; verbose=0)
	data = getData(strip(text))
	numbers = extrapolate2.(data)
	if 0 < verbose
		println(numbers)
	end
	sum(numbers)
end

# ╔═╡ b6ecc37b-0636-403e-a24c-9341c7dd1eb0
p2(e1; verbose=1)

# ╔═╡ 5a6da67b-0274-436b-8660-b5b5918de69c
inp = open(joinpath(@__DIR__, "data", "input09"), "r") do f
	read(f, String)
end

# ╔═╡ c699438c-66e2-4c0e-b0e9-60d66200e7d3
p1(inp)

# ╔═╡ 87482de9-936d-46f3-a183-757e3123ee71
# ╠═╡ show_logs = false
p2(inp)

# ╔═╡ e86c7391-e22b-4e08-9860-e8ff1fec19ae
begin
	@testset "Part 1" begin
		@test 114 == p1(e1)
		@test 1708206096 == p1(inp)
	end
	@testset "Part 2" begin
		@test 2 == p2(e1)
		@test 1050 == p2(inp)
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
# ╟─b890b8a2-9689-11ee-3f8b-f329feed1c73
# ╠═d700221d-30df-4e95-9478-b464d12f4e1a
# ╠═0bfa72de-ab60-4b1d-acbe-b2095f80c4b0
# ╠═c699438c-66e2-4c0e-b0e9-60d66200e7d3
# ╠═75fcc888-de8d-4533-b0f2-d13f3bf808ad
# ╠═b6ecc37b-0636-403e-a24c-9341c7dd1eb0
# ╠═87482de9-936d-46f3-a183-757e3123ee71
# ╠═e3c456f1-2a46-4087-a13d-4f12a1547d0d
# ╠═392f6612-e12d-40ce-bfec-6f8c9fe2fdd1
# ╠═ff071327-d025-444c-bf19-da9e0bc54311
# ╠═aa164608-7f12-4f84-b2ff-6ee2330da572
# ╠═08df431d-08ef-427c-8651-3960c21cc774
# ╠═e86c7391-e22b-4e08-9860-e8ff1fec19ae
# ╟─5a6da67b-0274-436b-8660-b5b5918de69c
# ╟─fc5cb01c-e1a5-4d98-81c4-3fa5b48d8581
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
