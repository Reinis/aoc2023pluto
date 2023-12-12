### A Pluto.jl notebook ###
# v0.19.35

using Markdown
using InteractiveUtils

# ╔═╡ 9e511f26-98ce-11ee-3957-cf7cae56d6d2
md"
# AoC 2023
## Day 12
"

# ╔═╡ cafc088b-58dc-4030-8e8d-2cc4ada2f072
e1 = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""

# ╔═╡ 0500a9ae-1dfa-4644-9438-a6744a81508f
match(r"(?<![#])[?#]{1}(?![#])", "?.", 1)

# ╔═╡ 1c9bcd94-3f3c-466c-89c1-0fbadbe2dc7b
function getFragmentRexes(lengths)
	fragments = []
	for l in lengths
		push!(fragments, "[?#]{$(l)}")
	end
	dot = "(?![#]).*(?<![#])"
	Regex("(?<![#])" * join(fragments, dot) * "(?![#])")
end

# ╔═╡ dbae529b-399c-4366-864d-954460c23b5b
function canMatch(springs, lengths, offset, rc)
	if haskey(rc, lengths)
		r = rc[lengths]
	else
		r = getFragmentRexes(lengths)
		rc[lengths] = r
	end
	m = match(r, springs, offset)
	# m === nothing
end

# ╔═╡ 80eaac94-09fc-4bd8-aebf-2459deec1168
function getVariations(springs, lengths, offset=2, mc=Dict(), rc=Dict())
	# println(" $springs", lengths, length(springs))
	key = (springs, lengths)
	if length(lengths) < 1
		println("hit zero")
		return 0
	end
	if haskey(mc, key)
		# println("has key", key, mc[key])
		return mc[key]
	end
	m = canMatch(springs, lengths, offset, rc)
	if isnothing(m)
		# println("not first")
		return mc[key] = 0
	end
	limit = 15
	n = 1
	o = m.offset
	result = length(lengths) > 1 ? 0 : 1
	# println(springs[o:end], m.offset, m.match, lengths, o)
	# @info "match" m lengths m.offset o mc rc
	if length(lengths) > 1
		u = m.offset + first(lengths)
		k = springs[u:end]
		ls = Base.tail(lengths)
		c = getVariations(k, ls, offset, mc, rc)
		result += c
		# println("c1=$c")
	else
		k = springs[o:end]
		c = getVariations(k, lengths, offset, mc, rc)
		result += c
		# println("c2=$c")
	end

	# @info "before loop" springs o k c lengths result mc
	k = springs[o:end]
	if 1 < length(lengths) && !isnothing(canMatch(k, lengths, offset, rc))
		c = getVariations(k, lengths, offset, mc, rc)
		result += c
		# println("c3=$c")
		# @info "loop" springs o k ls c result mc
	end

	@info "mc" springs lengths mc
	mc[key] = result
end

# ╔═╡ 82b8c5b2-f3dd-4b92-95cd-363e93903712
getVariations(".???.###.", (1,1,3))

# ╔═╡ 1c7d10a3-972f-4ab1-bec9-29ae8fbe608f
getVariations(".??..??...?##.", (1,1,3))

# ╔═╡ 907e4a9b-4628-460c-8f0f-c8aa68e37ccd
getVariations(".?#?#?#?#?#?#?#?.", (1,3,1,6))

# ╔═╡ 54d31410-cbd9-4070-b9d3-4822de6fea3b
getVariations(".????.#...#...", (4,1,1))

# ╔═╡ 97e4bdb0-a8d3-4503-b9d3-4256c2e8c657
getVariations(".????.######..#####.", (1,6,5))

# ╔═╡ 672cf030-11f7-4edd-8627-b78dc0a2224e
getVariations("????.######..#####.", (1,6,5))

# ╔═╡ fc5e06dc-6661-415f-94ea-e6df704419c5
getVariations(".?###????????.", (3,2,1))

# ╔═╡ 5db8ba3b-df2f-4a1c-a92e-97ae09fd7e1d
getVariations("?###????????", (3,2,1))

# ╔═╡ 5ca0969f-a54f-489f-a5e4-4fb4178a10e4
function extend(springs)
	replace(springs, r"^([#?])"=>s".\1", r"([#?])$"=>s"\1.")
end

# ╔═╡ 10da3738-a27f-4102-9ad3-593858eaae9c
function countVariations(spring; verbose=0)
	springs, lengths... = spring
	springs = extend(springs)
	0 < verbose && @info "spring" springs lengths
	variations = getVariations(springs, lengths)
	# length(variations)
end

# ╔═╡ 32feb586-0ba2-4cad-9690-5e681f750cb8
function getData(text)
	splitLines(x) = split(strip(x), "\n")
	splitSpace(x) = split(x, " ")
	splitComma(x) = split(x, ",")
	parseNumbers(x) = parse.(Int, x)
	getLengths = parseNumbers ∘ splitComma
	parseComma(x) = x[1], getLengths(x[2])...
	lines = text |> splitLines .|> splitSpace .|> parseComma
	lines
end

# ╔═╡ 6a997484-25de-40ed-941a-f126e374b5d8
function p1(text; verbose=0)
	springs = getData(text)
	counts = zeros(Int, length(springs))
	for (i, spring) in enumerate(springs)
		counts[i] = countVariations(spring; verbose)
	end
	0 < verbose && @info "broken variations" counts
	sum(counts)
end

# ╔═╡ 6a5d2d77-e5f9-4d63-958f-54e7e172c9b8
@time p1(e1; verbose=1)

# ╔═╡ 074f2532-09fa-4f71-a852-4d67a6de4538
inp = open(joinpath(@__DIR__, "data", "input12"), "r") do f
	read(f, String)
end

# ╔═╡ 5217136c-8a2a-4981-99de-c7acf9f73442
p1(inp)

# ╔═╡ 1dc61611-20c5-455c-8c9a-cfaadd9afc6a
# ╠═╡ disabled = true
#=╠═╡
function getVariations2(springs, lengths)
	rex = getFragmentRexes(lengths, length(springs))
	variations = collect(eachmatch(rex, springs; overlap=true))
	@info "rexes" rex variations
	variations
end
  ╠═╡ =#

# ╔═╡ Cell order:
# ╟─9e511f26-98ce-11ee-3957-cf7cae56d6d2
# ╠═cafc088b-58dc-4030-8e8d-2cc4ada2f072
# ╠═6a5d2d77-e5f9-4d63-958f-54e7e172c9b8
# ╠═5217136c-8a2a-4981-99de-c7acf9f73442
# ╠═6a997484-25de-40ed-941a-f126e374b5d8
# ╠═10da3738-a27f-4102-9ad3-593858eaae9c
# ╠═82b8c5b2-f3dd-4b92-95cd-363e93903712
# ╠═1c7d10a3-972f-4ab1-bec9-29ae8fbe608f
# ╠═907e4a9b-4628-460c-8f0f-c8aa68e37ccd
# ╠═54d31410-cbd9-4070-b9d3-4822de6fea3b
# ╠═97e4bdb0-a8d3-4503-b9d3-4256c2e8c657
# ╠═672cf030-11f7-4edd-8627-b78dc0a2224e
# ╠═0500a9ae-1dfa-4644-9438-a6744a81508f
# ╠═fc5e06dc-6661-415f-94ea-e6df704419c5
# ╠═5db8ba3b-df2f-4a1c-a92e-97ae09fd7e1d
# ╠═80eaac94-09fc-4bd8-aebf-2459deec1168
# ╠═dbae529b-399c-4366-864d-954460c23b5b
# ╠═1c9bcd94-3f3c-466c-89c1-0fbadbe2dc7b
# ╠═5ca0969f-a54f-489f-a5e4-4fb4178a10e4
# ╠═32feb586-0ba2-4cad-9690-5e681f750cb8
# ╟─074f2532-09fa-4f71-a852-4d67a6de4538
# ╠═1dc61611-20c5-455c-8c9a-cfaadd9afc6a
