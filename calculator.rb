require 'pry'
require_relative 'node'
require_relative 'graph'
include Graph

puts 'Enter jug capacities separated by comma:'
capacity_array = gets.chomp.split(',').map(&:to_i)

puts 'Enter starting capacities separated by comma:'
starting_array = gets.chomp.split(',').map(&:to_i)

puts 'Enter ending capacities separated by comma:'
ending_array = gets.chomp.split(',').map(&:to_i)

out_of_bounds = (0..capacity_array.length - 1).map do |i|
  starting_array[i] <= capacity_array[i] && ending_array[i] <= capacity_array[i] &&
    starting_array[i] >= 0 && ending_array[i] >= 0
end.include? false
constant_volume = starting_array.inject(:+) == ending_array.inject(:+)

if out_of_bounds
  puts 'Water level out of bounds'
  exit(0)
elsif !constant_volume
  puts 'Starting and ending water levels do not add up!'
  exit(0)
elsif [starting_array.length, ending_array.length, capacity_array.length].uniq.length > 1
  puts 'Number of jugs does not match'
  exit(0)
end

Node.const_set('Maxlevel', capacity_array)

node_list = []
puts "Checking if it is possible to get to final state
This may take a while...\n"
build_graph(starting_array, node_list)
# puts "graph size = #{node_list.length} nodes"
possible = node_list.include? Node.new(ending_array, false)

if possible
  puts "Attempting to find path with least number of steps.
This may take a while..."
  start_time = Time.now
  matrix = build_adjacency_matrix(node_list)
  paths = []
  Graph::all_paths = []
  visited = Array.new(node_list.length) { |e| e = false }
  start_index = node_list.index(Node.new(starting_array))
  end_index = node_list.index(Node.new(ending_array))

  find_path(
    matrix,
    start_index,
    end_index,
    visited,
    paths,
    start_time
  )

  if Graph::all_paths.length < 1
    puts 'Could not find the shortest path within given time'
  else
    end_time = Time.now
    puts "Found #{Graph::all_paths.length} paths in #{end_time - start_time} seconds"
    min_path = Graph::all_paths.min_by { |x| x.length }

    # puts "Found path with #{min_path.length} steps in #{end_time - start_time} seconds"
    puts 'Follow these steps to reach final state'
    # binding.pry
    min_path.each { |e| puts node_list[e].level.to_s }
  end
else
  puts 'Not possible to reach the final state'
end
