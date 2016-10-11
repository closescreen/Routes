using Routes
using Base.Test

r1 = Routes.route("./RESULT/",:day=>r"(\d\d\d\d-\d\d-\d\d)",".gz")
@test r1|>typeof == Routes.Route
@test r1.regex == r"./RESULT/(?P<day>(\d\d\d\d-\d\d-\d\d)).gz"

m1 = match( r1.regex, "./RESULT/2016-06-11.gz" )
@test m1 != nothing
@test m1.match == "./RESULT/2016-06-11.gz"
@test Routes.file( r1, m1.match) == "./RESULT/./RESULT/2016-06-11.gz.gz"



