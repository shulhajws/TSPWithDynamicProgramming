import math

def get_matrix_from_file(file_path):
    matrix = []
    with open(file_path, "r") as file:
        for line in file:
            elements = line.strip().split()
            matrix.append([int(element) for element in elements])
    return matrix


'''
Find optimum solution for Travelling Salesman Problem using Dynamic Programming
@param i : source
@param S : set of destinations 
'''
def tsp_with_dp(i, S):
    ''' Base : if S has only 1 item left, return distance from it to the ending point '''
    if (len(S) == 1):
        j = S.pop()
        return ([i, j, start_city],  adj_mtrx[i][j] + adj_mtrx[j][start_city])
 
    # Set default value for the result
    result = ([], 10**9)

    # Iterate through all item in S
    for j in S:

        ''' Recursion '''
        recursion = tsp_with_dp(j, S-{j})

        # Insert source to the result array
        recursion[0].insert(0,i)

        # Create new tuple for the result and add distance from source(i) to current destination (j)
        recursion_result = (recursion[0], recursion[1] + adj_mtrx[i][j])
    
        # Take result only if minimum, compared by the distance
        result = min(result, recursion_result, key=lambda x: x[1])

    return result


adj_mtrx = get_matrix_from_file("input_matrix.txt")
print(f"There are {len(adj_mtrx[0])} cities.")
start_city = int(input("Hi, salesman! Which cities you are going from? (Index from 0) "))
# Create set of coordinates index to evaluate
points_of_cities = set(range(0, len(adj_mtrx[0]))) - {start_city}

# Find solution using Dynamic Programming
tsp_with_dp_result = tsp_with_dp(start_city, points_of_cities)
print("Most optimum TSP route using Dynamic Programming: ", end=" ")
for place in tsp_with_dp_result[0]:
    print(place, end=" ")
print(f"\nApproximate distance to travel : {tsp_with_dp_result[1]}")



