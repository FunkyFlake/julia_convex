using Convex, SCS, Plots

# Data
k = 201
t = [-3 + 6*(i-1)/(k-1) for i ∈ 1:k]
tvec = [[1; t[i]; t[i]^2] for i ∈ 1:k]
y = [exp(t[i]) for i ∈ 1:k]


# Fit a rational function to the data
a = Variable(3);
b = Variable(2);

δ = 10;
while true
    sublevel1 = [a' * tvec[i] - (1 + b' * tvec[i][2:3]) * y[i] <=  δ * (1 + b' * tvec[i][2:3]) for i ∈ 1:k];
    sublevel2 = [a' * tvec[i] - (1 + b' * tvec[i][2:3]) * y[i] >= -δ * (1 + b' * tvec[i][2:3]) for i ∈ 1:k];

    objective = minimize(0);
    objective.constraints += sublevel1;
    objective.constraints += sublevel2;

    solve!(objective, SCS.Optimizer)
    if Int(objective.status) == 2
        break
    end
    
    aopt = evaluate(a)
    bopt = evaluate(b)
    δ = δ / 2;
end

plot(t, y, label="Ground truth", legend=:topleft);
plot!(t, [aopt' * tvec[i] / (1 + bopt' * tvec[i][2:3]) for i ∈ 1:k], label="rational fit")

