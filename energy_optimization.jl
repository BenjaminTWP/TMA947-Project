using JuMP, Ipopt
model = Model(Ipopt.Optimizer)
include("intro_data.jl")

#### CONSTRAINTS
@variable(model, lb_phase[k] <= phase[k=1:11] <= ub_phase[k])
@variable(model, lb_volt[k] <= voltage[k=1:11] <= ub_volt[k])
@variable(model, lb_generators[k] <= generator[k=1:n_generators] <= up_generators[k])
@variable(model, consumer_demand[k=1:n_consumers]) # TODO Better to have this as lower bound?


# Obkective function is the sum of the cost of producing the electricity in each generator
@NLobjective(model, Min, sum(cost_generator[k] * generator[k] for k in 1:n_generators))


#@NLconstraint()


println(model)

test = [voltage[3], voltage[4]]
# println(test)

# @NLconstraint(model, SOS_constr, sum(x[i]^2 for i in 1:n_vars) <= sum_bound)
