using Convex, SCS

# Random data
m = 4; n = 5;
A = randn(m, n); b = randn(m);

# Create a (column vector) variable of size n x 1.
x = Variable(n)

# The problem is to minimize ||Ax - b||^2 subject to x >= 0
# This can be done by: minimize(objective, constraints)
problem = minimize(sumsquares(A * x - b), [x >= 0])

solve!(problem, SCS.Optimizer)

# Check the status of the problem
problem.status

# Get the optimal value
problem.optval
evaluate(x)