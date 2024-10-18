using JuMP, Ipopt
model = Model(Ipopt.Optimizer)
include("intro_data.jl")

#### CONSTRAINTS
@variable(model, lb_phase[k] <= θ[k=1:11] <= ub_phase[k])
@variable(model, lb_volt[k] <= v[k=1:11] <= ub_volt[k])
@variable(model, lb_generators[k] <= generator[k=1:n_generators] <= ub_generators[k])
@variable(model, lb_reactive[k] <= reactive[k=1:n_generators] <= ub_reactive[k])

# Objective function is the sum of the cost of producing the electricity in each generator
@NLobjective(model, Min, sum(cost_generator[k] * generator[k] for k in 1:n_generators))


@NLconstraint(model, activePower[n = 1:n_len], 
                (sum(generator[index] for index in generators_index[n]; init=0) # Generators
                - sum(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb]) for nb in neighbours[n]) # Outgoing FROM N TO NB
                + sum(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n]) for nb in neighbours[n]) # Incoming FROM NB TO N
                - sum(consumer_demand[index] for index in consumers_index[n]; init=0)) # Consumed 
                == 0)
    
@NLconstraint(model, reactivePower[n = 1:n_len], 
                (sum(reactive[index] for index in generators_index[n]; init=0) # Generators
                - sum(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb]) for nb in neighbours[n]) # Outgoing FROM N TO NB
                + sum(-v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n]) for nb in neighbours[n])) # Incoming FROM NB TO N
                == 0)

#println(model)


# Solve the optimization problem
optimize!(model)

# Printing some of the results for further analysis
println("") # Printing white line after solver output, before printing
println("Termination statue: ", JuMP.termination_status(model))
println("Optimal(?) objective function value: ", JuMP.objective_value(model))
println("Generator")
println("Optimal(?) point: ", JuMP.value.(generator))
println("Volt")
println("Optimal(?) point: ", JuMP.value.(v))
println("θ")
println("Optimal(?) point: ", JuMP.value.(θ))
println("Reactive")
println("Optimal(?) point: ", JuMP.value.(reactive))


println("Active power:")
for n in 1:n_len
    println("   Flows from node $n")
    for nb in neighbours[n]
        net_flow = 
                JuMP.value.(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb])) #  FROM N TO NB
                - JuMP.value.(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n])) #  FROM NB TO N
        println("From node $n to node $nb the net flow is $net_flow")
    end
end

println("")

println("Reactive power:")
for n in 1:n_len
    println("   Flows from node $n")
    for nb in neighbours[n]
        net_flow =
            #JuMP.value.(sum(reactive[index] for index in generators_index[n]; init=0)) # Generators 
            JuMP.value.(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb])) #  FROM N TO NB
            - JuMP.value.(-v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n])) #  FROM NB TO N
        println("From node $n to node $nb the net flow is $net_flow")
    end
end

for n in 1:n_len
    println("for node $n")
    for index in generators_index[n]
        println(JuMP.value.(reactive[index]))
    end
end


