using Convex, SCS
using DelimitedFiles
using Plots

# Ground truth
A_gt = readdlm("sparse_lds_A.txt", ' ', Float64)
B_gt = readdlm("sparse_lds_B.txt", ' ', Float64)
# Known Covariance
W = readdlm("sparse_lds_W.txt", ' ', Float64)
# Known inputs and states
u = readdlm("sparse_lds_u.txt", ' ', Float64)
x = readdlm("sparse_lds_x.txt", ' ', Float64)

# take sqrt of W
σ = sqrt.(W)
σ_inv = inv(σ)

# Estimate Dynamics
n = size(A_gt, 1)
m = size(B_gt, 2)
T = size(u, 1)

A = Variable(n, n)
B = Variable(n, m)

SE = [square(norm(σ_inv*(x[t+1,:] - A*x[t,:] - B*u[t,:]))) for t in 1:T-1];
SSE = sum(SE);
plausibility = SSE <= n*(T-1) + 2*sqrt(2*n*(T-1));

objective = minimize(norm(vec(A), 1) + norm(vec(B), 1))
objective.constraints += plausibility

solve!(objective, SCS.Optimizer)

A = evaluate(A)
B = evaluate(B)

# set all elements to zero where |A| <= 0.01
A[abs.(A) .<= 0.01] .= 0
B[abs.(B) .<= 0.01] .= 0

println("A_gt")
A_gt
println("A")
A
println("B_gt")
B_gt
println("B")
B

# Simulate estimated system
x_est = zeros(T, n)
x_est[1,:] = x[1,:]
for t in 1:T-1
    x_est[t+1,:] = A*x_est[t,:] + B*u[t,:]
end

# Plot some of the results
plot(x[:,1], label="Ground truth", legend=:topleft);
plot!(x_est[:,1], label="Estimated", title="State 1")