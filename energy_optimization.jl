using JuMP, Ipopt
model = Model(Ipopt.Optimizer)
include("intro_data.jl")

# Phase constraints
@variable(model, z[i=1:11], lower_bound = -π, upper_bound = π)
@variable(model, lb_volt[j] <= voltage[j=1:11] <= ub_volt[j])
@variable(model, lb_generators[k] <= generator[k=1:n_generators] <= up_generators[k])


test = [voltage[3], voltage[4]]
println(test)

#@NLconstraint(model, SOS_constr, sum(x[i]^2 for i in 1:n_vars) <= sum_bound)

messages = "helloworld"

println(messages)