# Small data file to show how one can import julia files into other julia files.
# It, e.g., gives a convenient way to create files containing all the data for a problem.

n_vars = 2 # Number of variables
lb = [-1, -4] # Lower bounds for the variables
ub = [3, 0] # Upper bounds for the variable
sum_bound = 0.49 # Constraint on sum of variables

neighbours = [[2,11], [1,3,11], [2,4,9], [3,5],[4,6,8], [5,7], [6,8,9], [5,7,9], [3,7,8,10], [9,11], [1,2,10]]

n_generators = 9
lb_generators = [0, 0, 0, 0, 0, 0, 0, 0, 0]
up_generators = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05]
cost_generator = [175, 100, 150, 150, 300, 350, 400, 300, 200]

n_consumers = 7
consumer_demand = [0.10, 0.19, 0.11, 0.09, 0.21, 0.05, 0.04]

n_theta = 11
lb_phase = [-pi for n=1:n_theta]
ub_phase = [pi for n=1:n_theta]

n_voltage = 11
lb_volt = [0.98 for n=1:n_voltage]
ub_volt = [1.02 for n=1:n_voltage]

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
