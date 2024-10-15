include("energy_optimization.jl") 
####
    #]
# TESTS
#
###
global net_flow = 0
println("Active power:")
for n in 1:n_len
    local net_flow_n = 0 
    #println("   Flows from node $n")
    for nb in neighbours[n]
        local flow = sum(JuMP.value.(v[n]^2 * G[n, nb] - v[n] * v[nb] * G[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * B[n, nb] * sin(θ[n] - θ[nb])))
        flow -= sum(JuMP.value.(v[nb]^2 * G[nb, n] - v[nb] * v[n] * G[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * B[nb, n] * sin(θ[nb] - θ[n])))

       
        net_flow_n += flow
        #println("From node $n to node $nb the net flow is $flow")
    end
    global net_flow += net_flow_n  # Update the global running sum
    #println("Net flow for node $n: $net_flow_n")
end
println("Total active net flow: $net_flow") 


global net_flow = 0  
println("Reactive power:")
for n in 1:n_len
    local net_flow_n = 0 
    #println("   Flows from node $n")
    for nb in neighbours[n]
        local flow = sum(JuMP.value.(-v[n]^2 * B[n, nb] + v[n] * v[nb] * B[n, nb] * cos(θ[n] - θ[nb]) - v[n] * v[nb] * G[n, nb] * sin(θ[n] - θ[nb]))) # Reactive power flowing from n to nb
        flow -= sum(JuMP.value.(-v[nb]^2 * B[nb, n] + v[nb] * v[n] * B[nb, n] * cos(θ[nb] - θ[n]) - v[nb] * v[n] * G[nb, n] * sin(θ[nb] - θ[n]))) # Reactive power flowing from n to nb
    
    
        net_flow_n += flow
       # println("From node $n to node $nb the net flow is $flow")
    end
    global net_flow += net_flow_n  
end
println("Total reactive net flow: $net_flow") 




