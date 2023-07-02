using Convex, SCS
using Plots

# Problem parameters
T = 30  
Tstart = 15
Tend = 20
Smin = 25
Smax = 35
L = 3.7

p = Variable(T,2)
velocities = norm2.([p[t+1,:] - p[t,:] for t ∈ 1:T-1])
xvelocities = [p[t+1,1] - p[t,1] for t ∈ 1:T-1]

accelerations = [p[t+1] - 2p[t] + p[t-1] for t ∈ 2:T-1] 
SSE = sum(square.(norm2.(accelerations))) 

objective = minimize(SSE, [
    # Initial Position
    p[1,:] == 0
    # Lane boundaries
    p[:,2] >= 0                
    p[:,2] <= L
    # Lane change time frame
    p[Tend:end,2] == L
    p[1:Tstart,2] == 0
    # Velocity constraints
    velocities .<= Smax
    xvelocities[1:Tstart] .>= Smin
    # xvelocities[Tend+1:end] .>= Smin
    xvelocities .>= 0
])

solve!(objective, SCS.Optimizer)

pos = evaluate(p)
v = [pos[t+1,:] - pos[t,:] for t ∈ 1:T-1]
v = hcat(v...)'
vmag = [norm2(v[t,:]) for t ∈ 1:T-1]
a = [v[t+1,:] - v[t,:] for t ∈ 1:T-2]
a = hcat(a...)'
amag = [norm2(a[t,:]) for t ∈ 1:T-2]

plotly()
plot(pos[:,1], pos[:,2], xlabel="x", ylabel="y", size=(1000,500))
scatter!([pos[:,1]], [pos[:,2]]);
scatter!([pos[Tstart,1]], [pos[Tstart,2]], label="Tstart");
scatter!([pos[Tend,1]], [pos[Tend,2]], label="Tend")

p1 = plot(vmag, label="Velocity Magnitude");
p2 = plot(amag, label="Acceleration Magnitude");
p3 = plot(v[:,1], label="Velocity x");
p4 = plot(a[:,1], label="Acceleration x");
p5 = plot(v[:,2], label="Velocity y");
p6 = plot(a[:,2], label="Acceleration y");
plot(p1,p2,p3,p4,p5,p6, layout=(6,1), size=(1200,900))
