using Convex, SCS

x = Variable()
y = Variable()
z = Variable()

# Not DCP compliant because of sqrt
a = sqrt(1 + 4*square(x) + 16*square(y))

b = min(x, log(y))- max(y,z)

# Not DCP compliant because of log of sum
c = log(exp(2*x + 3) + exp(4*y + 5))
c2 = logsumexp([(2*x + 3) (4*y + 5)])


