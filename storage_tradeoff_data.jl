using Plots
using Random
Random.seed!(1)

T = 96; # 15 minute intervals in a 24 hour period
t = 1:T;
pi = 3.14159265;
p = exp.(-cos.((t.-15)*2*pi/T) + 0.01*randn(T));
u = 2*exp.(-0.6*cos.((t.+40)*pi/T) - 0.7*cos.(t.*4*pi/T)+0.01*randn(T));

## Optimize charging profile of battery
using Convex, SCS

c = Variable(T)
q = Variable(T)

# Constraints
Q = 35 # max battery charge
C = 3 #1  # max charging rate
D = 3 #1  # max discharging rate

# Limit charge in battery
c1 = (q >= 0)
c2 = (q <= Q)
# Limit charging rate
c3 = (c <= C)
c4 = (c >= -D)
# Ensure same charge in the end as the beginning
c5 = (q[1] == q[end] + c[end])
# Connect charge and charging rate
c6 = [q[i+1] == q[i] + c[i] for i in 1:T-1]
# Initial charge
# c7 = (q[1] == 20)

constraints = [c1, c2, c3, c4, c5]
constraints = cat(constraints, c6, dims=1)
# constraints += c7

# Objective
objective = minimize(dot(p, u + c))
objective.constraints = constraints

solve!(objective, SCS.Optimizer)

# Plot results
p0 = plot(t, p, label="Price", color="red")
p1 = plot(t, u, label="Consumption", color="black")
p2 = plot(t, evaluate(c), label="Charging Profile", color="blue")
p3 = plot(t, evaluate(q), label="Battery Charge", color="purple")

plot(p0, p1, p2, p3, layout=(4,1), legend=:right)

# Save plot
savefig("storage_tradeoff_data.png")
