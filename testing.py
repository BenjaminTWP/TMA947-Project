

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

print(len(final_list))
print(final_list)