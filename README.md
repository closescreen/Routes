# Routes

[![Build Status](https://travis-ci.org/closescreen/Routes.jl.svg?branch=master)](https://travis-ci.org/closescreen/Routes.jl)

[![Coverage Status](https://coveralls.io/repos/closescreen/Routes.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/closescreen/Routes.jl?branch=master)

[![codecov.io](http://codecov.io/github/closescreen/Routes.jl/coverage.svg?branch=master)](http://codecov.io/github/closescreen/Routes.jl?branch=master)



julia> r1 = Routes.route("./RESULT/",:day=>r"(\d\d\d\d-\d\d-\d\d)",".gz")
Routes.Route(Any[Routes.NamedParam(2,:day,r"(\d\d\d\d-\d\d-\d\d)")],Any["./RESULT/",Routes.Part(1),".gz"],r"./RESULT/(?P<day>(\d\d\d\d-\d\d-\d\d)).gz")

julia> r1.regex
r"./RESULT/(?P<day>(\d\d\d\d-\d\d-\d\d)).gz"

julia> m1 = match( r1.regex, "./RESULT/2016-06-11.gz" )
RegexMatch("./RESULT/2016-06-11.gz", day="2016-06-11", 2="2016-06-11")

julia> Routes.file( r1, m1.match)
"./RESULT/./RESULT/2016-06-11.gz.gz"
