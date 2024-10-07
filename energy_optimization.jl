using JuMP, Ipopt
model = Model(Ipopt.Optimizer)

# Phase constraints
@variable(model, z[i=1:11], lower_bound = -π, upper_bound = π)



messages = "helloworld"

println(messages)