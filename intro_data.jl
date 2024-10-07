# Small data file to show how one can import julia files into other julia files.
# It, e.g., gives a convenient way to create files containing all the data for a problem.

n_vars = 2 # Number of variables
lb = [-1, -4] # Lower bounds for the variables
ub = [3, 0] # Upper bounds for the variable
sum_bound = 0.49 # Constraint on sum of variables

neighbours = [[2,11], [1,3,11], [2,4,9], [3,5],[4,6,8], [5,7], [6,8,9], [5,7,9], [3,7,8,10], [9,11], [1,2,10]]
display(neighbours)

n_generators = 9
lb_generators = [0, 0, 0, 0, 0, 0, 0, 0, 0]
up_generators = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05]
cost_generator = [175, 100, 150, 150, 300, 350, 400, 300, 200]

n_consumers = 7
consumer_demand = [0.10, 0.19, 0.11, 0.09, 0.21, 0.05, 0.04]

n_theta = 11
lb_theta = [-4 for n=1:n_theta]
ub_theta = [4 for n=1:n_theta]

n_voltage = 11
lb_volt = [0.98 for n=1:n_voltage]
ub_volt = [1.02 for n=1:n_voltage]
