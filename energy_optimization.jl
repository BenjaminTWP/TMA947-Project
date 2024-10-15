using JuMP, Ipopt
model = Model(Ipopt.Optimizer)
include("intro_data.jl")

for row in eachrow(B)
    println(row)
end
#### CONSTRAINTS
@variable(model, lb_phase[k] <= θ[k=1:11] <= ub_phase[k])
@variable(model, lb_volt[k] <= v[k=1:11] <= ub_volt[k])
@variable(model, lb_generators[k] <= generator[k=1:n_generators] <= ub_generators[k])
@variable(model, lb_reactive[k] <= reactive[k=1:n_generators] <= ub_reactive[k])

# Objective function is the sum of the cost of producing the electricity in each generator
@NLobjective(model, Min, sum(cost_generator[k] * generator[k] for k in 1:n_generators))

# n  = k
# nb = l
@NLconstraint(model, activePower[n = 1:n_len], 
                (sum(generator[index] for index in generators_index[n]) # Generators
                + sum(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb]) for nb in neighbours[n]) # Incoming FROM NB TO N
                - sum(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n]) for nb in neighbours[n]) # Outgoing FROM N TO NB
                - sum(consumer_demand[index] for index in consumers_index[n])) # Consumed 
                == 0)
    
@NLconstraint(model, reactivePower[n = 1:n_len], 
                (sum(reactive[index] for index in generators_index[n]) # Generators
<<<<<<< HEAD
                + sum(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb] -(v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n])) for nb in neighbours[n])) # Outgoing FROM N TO NB
                == 0)   )
=======
                + sum(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb]) for nb in neighbours[n]) # Incoming FROM NB TO N
                - sum(-v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n]) for nb in neighbours[n])) # Outgoing FROM N TO NB
                == 0)
>>>>>>> 7e8f98897631fe4a72011213d69a199865dfa10c

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

global net_flow = 0  # Initialize net_flow globally if it's used outside the loop as well.
println("Active power:")
for n in 1:n_len
    local net_flow_n = 0  # Initialize a local running sum for each node n.
    println("   Flows from node $n")
    for nb in neighbours[n]
        local flow = sum(JuMP.value.(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb])))
        flow -= sum(JuMP.value.(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n])))

        # Update the local sum for this node
        net_flow_n += flow
        println("From node $n to node $nb the net flow is $flow")
    end
    global net_flow += net_flow_n  # Update the global running sum
    println("Net flow for node $n: $net_flow_n")
end
println("Total net flow: $net_flow")  # Display the total net flow

#=

println("Active power:")
for n in 1:n_len
    println("   Flows from node $n")
    for nb in neighbours[n]
        net_flow = 
                - sum(JuMP.value.(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb]))) # Incoming FROM NB TO N
                + sum(JuMP.value.(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n]))) # Outgoing FROM N TO NB
        println("From node $n to node $nb the net flow is $net_flow")
    end
end

println("")

println("Reactive power:")
for n in 1:n_len
    println("   Flows from node $n")
    for nb in neighbours[n]
        net_flow = 
            - sum(JuMP.value.(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb]))) # Incoming FROM NB TO N
            + sum(JuMP.value.(-v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n]))) # Outgoing FROM N TO NB
        println("From node $n to node $nb the net flow is $net_flow")
    end
end

=#