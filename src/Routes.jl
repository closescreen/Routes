module Routes

immutable Route
 params::Array
 parts::Array 
 regex::Regex 
end

abstract Param
immutable NamedParam
 partindex::Int
 name::Symbol
 regex::Regex
end
immutable PositionalParam
 partindex::Int
 regex::Regex
end

immutable Part
 paramindex::Int
end 

export route
"""
r1 = route(\"../RESULT/\", 
    :day=>r\"\\d\\d\\d\\d-\\d\\d-\\d\\d\", \".gz\")

Create a route. Parameters may be:
    
    string - will joined as is,
    
    Pair(Symbol,Regex) - parameter for creating concrete file name
 
"""
function route(args...) 
 params_arr = params(args...)
 parts_arr = [part(i,x,params_arr) for (i,x) in enumerate(args)]
 pattern_re = pattern(args...)
 Route(params_arr, parts_arr, pattern_re)
end
 

params(args...) = enumerate(args)|> 
    e->[param(i,a) for(i,a) in e] |>
    arr->filter(p->p!=nothing, arr) |> collect
    
param(i::Int, p::Pair{Symbol,Regex}) = NamedParam(i, p[1], p[2])
param(i::Int, re::Regex) = PositionalParam(i, re)
param(i::Int, x)=nothing

part(i::Int,x::AbstractString,params) = x
part(i::Int,x,params) = findfirst(p->p.partindex==i, params)|> i->Part(i)

pattern(args...) = Regex(join(map(string,args),""))
import Base.string
string(p::Pair{Symbol,Regex}) = "(?P<$(p[1])>$(p[2].pattern))"
string(r::Regex) = "($(r.pattern))"

export file
"""
r1 = route(\"../RESULT\", :day=>r\"\\d\\d\\d\\d-\\d\\d-\\d\\d\", 
    \".gz\") # named param

r1 = route(\"../RESULT\", r\"\\d\\d\\d\\d-\\d\\d-\\d\\d\", 
    \".gz\") # positional param


f1 = file(r1, \"2016-08-09\") # \"../RESULT/2016-08-09.gz\"

r1.regex # r\"../RESULT/(?P<day>\d\d\d\d-\d\d-\d\d).gz\"

match(r1.regex,f1) # RegexMatch(\"../RESULT/2016-08-09.gz\", day=\"2016-08-09\")

"""
function file(r::Route, pars...)
 if length(pars)!=length(r.params)
    error("Count of params not equal. $(r.params|>length) != $pars")
 end
 join([ yeld(r,p,pars) for p in r.parts ],"")
 
end

check(r::Regex,s::AbstractString) = ismatch(r,s)
check(r::Regex,x) = check(r,string(x))

yeld(r::Route, p::AbstractString, pars) = p
function yeld(r::Route, p::Part, pars) 
    userparam = pars[p.paramindex]
    routeparam = r.params[p.paramindex]
    if !check(routeparam.regex, userparam)
	error("Param #$(p.paramindex) (:$(routeparam)) must match with $(routeparam.regex)")
    end
    userparam
end


end # module
