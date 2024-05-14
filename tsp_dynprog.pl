use strict;
use warnings;
use List::Util qw(min);

my @adj_matrix;
my $start_city;

# Read the adjacency matrix from a file
sub get_matrix_from_file {
    my ($file_path) = @_;
    
    open my $file, '<', $file_path or die "Could not open file: $!";
    while (my $line = <$file>) {
        chomp $line;
        push @adj_matrix, [split(/\s+/, $line)];
    }
    close $file;
}

#Checking if the matrix valid
sub is_matrix_valid {
    my ($matrix) = @_;
    my $num_rows = @$matrix;
    return 0 unless $num_rows > 0;  

    my $num_cols = @{$matrix->[0]};
    foreach my $row (@$matrix) {
        return 0 unless @$row == $num_cols; 
    }

    return 1;
}

# Solve the TSP using dynamic programming
sub tsp_with_dp {
    my ($i, @S) = @_;
    
    # Base case: if S has only 1 item left, return distance from it to the starting point
    if (scalar(@S) == 1) {
        my $j = $S[0];
        return ([$i, $j, $start_city], $adj_matrix[$i][$j] + $adj_matrix[$j][$start_city]);
    }
    
    #Declaring minimum distance as a very large number
    my @result = (undef, 10**9);
    
    for my $j (@S) {
        my @new_S = grep { $_ != $j } @S;
        
        # Recursion
        my ($path, $cost) = tsp_with_dp($j, @new_S);
        unshift @$path, $i;  # Insert source to the result array
        my $recursion_result = ([$path, $cost + $adj_matrix[$i][$j]]);
        @result = ($result[1] > $recursion_result->[1]) ? @$recursion_result : @result;
    }
    
    return @result;
}

# -------------------- MAIN PROGRAM -------------------------
print "Hi, salesman! Load the input matrix file of your map. Write 'input_matrix_X.txt': ";
chomp(my $input_matrix_file = <STDIN>);
get_matrix_from_file($input_matrix_file);
if (!is_matrix_valid(\@adj_matrix)){
    die "The matrix is not valid.\n";
}

my $num_of_cities = scalar @{$adj_matrix[0]};
print "There are ", $num_of_cities, " cities.\n";
print "Hi, salesman! Which city are you going from? (Index from 0) ";
chomp($start_city = <STDIN>);
if ($start_city < 1 || $start_city > $num_of_cities) {
    die "The value of ($start_city) is out of the range 1 to $num_of_cities.\n";
}
$start_city -= 1;

my @points_of_cities = grep { $_ != $start_city } 0..$#{$adj_matrix[0]};

my ($path, $cost) = tsp_with_dp($start_city, @points_of_cities);
print "Most optimum TSP route using Dynamic Programming: ";
my @incremented_path = map { $_ + 1 } @$path;
print join(" ", @incremented_path), "\n";
print "Approximate distance to travel: $cost\n";
