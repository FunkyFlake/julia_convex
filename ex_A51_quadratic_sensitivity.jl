using Convex, SCS

x = Variable(2)

# Inequality constraints
u1 = -2
u2 = -3

# Perturbations
δ1 = 0#.1
δ2 = 0#.1

c1 = x[1] + 2x[2] <= u1 + δ1
c2 = x[1] - 4x[2] <= u2 + δ2
c3 = 5x[1] + 76x[2] <= 1


# Quadratic Objective function
P = [ 1   -0.5;
     -0.5  2   ]

objective = minimize(quadform(x, P) - x[1])
objective.constraints += c1
objective.constraints += c2
objective.constraints += c3


solve!(objective, SCS.Optimizer)

x_opt = evaluate(x)
p = objective.optval

λ1 = objective.constraints[1].dual
λ2 = objective.constraints[2].dual
λ3 = objective.constraints[3].dual

# Check KKT conditions:
# Feasability of primal
f1 = x_opt[1] + 2x_opt[2] - u1
f2 = x_opt[1] - 4x_opt[2] - u2
f3 = 5x_opt[1] + 76x_opt[2] - 1

[f1 f2 f3] .<= 1e-3

# λ >= 0
[λ1 λ2 λ3] .>= -1e-3 

# Check inequalitiy constraints for complementary slackness
isapprox(f1*λ1, 0, atol=1e-3)  
isapprox(f2*λ2, 0, atol=1e-3)
isapprox(f3*λ3, 0, atol=1e-3)

# Gradient condition
gradL = [2x_opt[1] - x_opt[2] - 1 +  λ1 +  λ2 +  5λ3;
         4x_opt[2] - x_opt[1]     + 2λ1 - 4λ2 + 76λ3]

isapprox(gradL, zeros(2), atol=1e-3)
