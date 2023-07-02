using Convex, SCS, COSMO

Σ = Semidefinite(4)

x = [0.1; 0.2; -0.05; 0.1]

problem_wc = maximize(quadform(x, Σ), 
            [
                # Known variances
                Σ[1,1] == 0.2,
                Σ[2,2] == 0.1,
                Σ[3,3] == 0.3,
                Σ[4,4] == 0.1,
                # Only inequality knowledge about covariances
                Σ[1,2] >= 0,
                Σ[1,3] >= 0,
                Σ[2,3] <= 0,
                Σ[2,4] <= 0,
                Σ[3,4] >= 0
            ])

problem_diag = maximize(quadform(x, Σ), 
            [
                # Known variances
                Σ[1,1] == 0.2,
                Σ[2,2] == 0.1,
                Σ[3,3] == 0.3,
                Σ[4,4] == 0.1,
            ])


# Worst case variance
solve!(problem_wc, SCS.Optimizer)
σ2_wc =  problem_wc.optval
Σ_wc = evaluate(Σ)

solve!(problem_diag, SCS.Optimizer)
σ2_diag =  problem_diag.optval
Σ_diag = evaluate(Σ)


# Other example: https://inst.eecs.berkeley.edu/~ee127/sp21/livebook/l_sdp_apps_wc_risk.html
Σ = Semidefinite(3)
x = [0.1; 0.5; 0.4]

problem_wc = maximize(quadform(x, Σ),
                [
                # Known variances
                Σ[1,1] == 0.1,
                Σ[2,2] == 0.03,
                Σ[3,3] == 0.6,
                
                # Only inequality knowledge about covariances
                Σ[1,2] >= 0,
                Σ[1,3] <= 0
                ])
                
                problem_bc = minimize(quadform(x, Σ),
                [
                # Known variances
                Σ[1,1] == 0.1,
                Σ[2,2] == 0.03,
                Σ[3,3] == 0.6,

                # Only inequality knowledge about covariances
                Σ[1,2] >= 0,
                Σ[1,3] <= 0
                ])

# Worst case variance
solve!(problem_wc, SCS.Optimizer)
σ2_wc = problem_wc.optval 
Σ_wc = evaluate(Σ)

# Best case variance
solve!(problem_bc, SCS.Optimizer)
σ2_bc = problem_bc.optval 
Σ_bc = evaluate(Σ)
