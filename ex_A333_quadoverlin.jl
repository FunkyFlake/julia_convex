using Convex, SCS

# Additional Exercises for convex optimization by Boyd
# Exercise A3.33

x = Variable()
y = Variable()

z = quadoverlin(x, sqrt(y))

objective = norm([1 z])

