# Define the number of nodes
n = 11

# Initialize B and G matrices with zeros
B = zeros(n, n)
G = zeros(n, n)

# Populate B and G based on the given edges and coefficients
edges = [(1, 2), (1, 11), (2, 3), (2, 11), (3, 4), (3, 9), (4, 5), (5, 6), (5, 8), (6, 7), (7, 8), (7, 9), (8, 9), (9, 10), (10, 11)]
b_coeffs = [-20.1, -22.3, -16.8, -17.2, -11.7, -19.4, -10.8, -12.3, -9.2, -13.9, -8.7, -11.3, -7.7, -13.5, -26.7]
g_coeffs = [4.12, 5.67, 2.41, 2.78, 1.98, 3.23, 1.59, 1.71, 1.26, 1.11, 1.32, 2.01, 4.41, 2.14, 5.06]

# Assign coefficients to corresponding locations in the matrices
for ((k, l), b, g) in zip(edges, b_coeffs, g_coeffs)
    B[k, l] = b
    G[k, l] = g
    # Assuming undirected network, symmetric matrix
    B[l, k] = b
    G[l, k] = g
end

# Display matrices
println("Susceptance Matrix B:")
println(B)
println("\nConductance Matrix G:")
println(G)
