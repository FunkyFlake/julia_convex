using Convex, SCS

x = Variable()
y = Variable()
z = Variable()

expr = x + y + z

problem = minimize(expr, [x >= 1, y >= x, 4 * z >= y])

solve!(problem, SCS.Optimizer)

x.value
y.value
z.value

# Semidefinite constraint on variables
X = Variable(3,3)
y = Variable(3,1)
z = Variable()

constr = ([X y; y' z] in :SDP)
constr = ([X y; y' z] >= 0)

