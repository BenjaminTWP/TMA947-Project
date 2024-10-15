

list =  [1.0192317587342137, 1.0188278616468347, 1.0190174389401743, 1.0197419627227469, 1.0194958166067778, 1.0197667112930022, 1.019578873046477, 1.0199999522305883, 1.019024834434092, 1.0192253125869004, 1.0191626999183236]
new_list = []
for element in list:
        new_list.append(round(element, 6))

generators = []
for i in range(len(list)):
        generators.append(i + 1)

final_list =[]
fish = zip(generators, new_list)
for el1, el2 in fish:
        final_list.append(f"Volt {el1} : {el2}")


maximum = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05]
generating = [0.020000009942614277, 0.1500000099598905, 0.08000000994985046, 0.07000000994984801, 0.04000000979874183, 0.1199999404663756, -9.799632571853605e-9, 0.2600000097992102, 0.05000000993310164]
new_list2 = []
for el1, el2 in zip(maximum, generating):
        new_list2.append(el2/el1)
print(new_list2)


        