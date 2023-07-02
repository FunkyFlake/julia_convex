using Convex, SCS

p = [Variable() for i in 1:16]
p = reshape(p, 2,2,2,2)

T = 2 # True and false for easier readability
F = 1

c0 = sum(p[:,:,:,:]) == 1.0
# For X1
c1 = sum(p[T,:,:,:]) == 0.9
c2 = sum(p[F,:,:,:]) == 0.1
# For X2
c3 = sum(p[:,T,:,:]) == 0.9
c4 = sum(p[:,F,:,:]) == 0.1
# For X3
c5 = sum(p[:,:,T,:]) == 0.1
c6 = sum(p[:,:,F,:]) == 0.9
# For X4
c7 = sum(p[:,:,:,T]) >= 0.0
c8 = sum(p[:,:,:,F]) >= 0.0
c9 = sum(p[:,:,:,T]) <= 1.0
c10 = sum(p[:,:,:,F]) <= 1.0
c11 = sum(p[:,:,:,T]) + sum(p[:,:,:,F]) == 1.0

c12 = sum(p[T,:,T,F]) == 0.7 * sum(p[:,:,T,:])  # Conditional Probability 
c13 = sum(p[:,T,F,T]) == 0.6 * sum(p[:,T,F,:])

c14 = reshape(p .>= 0.0, 16) 
c15 = reshape(p .<= 1.0, 16)
constraints = [c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13]
constraints += c14
constraints += c15

# find feasible pdf with minimal probability of X4 being true
objective = minimize(sum(p[:,:,:,T])) 
objective.constraints += constraints

solve!(objective, SCS.Optimizer)

# Probability for X4 being true
x4min = evaluate(sum(p[:,:,:,T]))
evaluate(sum(p[:,:,:,F]))

# find feasible pdf with maximal probability of X4 being true
objective = maximize(sum(p[:,:,:,T])) 
objective.constraints += constraints

solve!(objective, SCS.Optimizer)

# Probability for X4 being true
x4max = evaluate(sum(p[:,:,:,T]))
evaluate(sum(p[:,:,:,F]))

println("Minimal probability of X4==true: ", x4min)
println("Maximal probability of X4==true: ", x4max)
println("Range: ", x4max - x4min)