using Convex,SCS,Plots

A = randn(100, 30);
b = randn(100, 1);

x = Variable(30);

l1 = norm(A*x - b, 1);
l2 = norm(A*x - b, 2);
l15 = norm(A*x - b, 1.5);

obj_L1 = minimize(l1);
obj_L2 = minimize(l2);
obj_L15 = minimize(l15);

solve!(obj_L1, SCS.Optimizer);
l1_loss = evaluate(obj_L1.optval)
xl1 = evaluate(x);

solve!(obj_L2, SCS.Optimizer);
l2_loss = evaluate(obj_L2.optval)
xl2 = evaluate(x);

solve!(obj_L15, SCS.Optimizer);
l15_loss = evaluate(obj_L15.optval)
xl15 = evaluate(x);

# Histogram of the residuals
h1 = histogram(A*xl1 - b, label="L1 loss", alpha=0.5, bins=-3:0.1:3, xlim=(-3,3), ylim=(0, 20));
h2 = histogram(A*xl2 - b, label="L2 loss", alpha=0.5, bins=-3:0.1:3, xlim=(-3,3), ylim=(0, 20));
h3 = histogram(A*xl15 - b, label="L1.5 loss", alpha=0.5, bins=-3:0.1:3, xlim=(-3,3), ylim=(0, 20)) ;

plot(h1, h2, h3, layout=(3,1), legend=:topleft)