#!/usr/bin/env ruby
require 'pry'
require_relative 'node'
require_relative 'graph'

class Calculator
  include Graph

  def calculate
    non_numeric_input = false

    puts 'Enter jug capacities separated by comma:'
    capacity_array = gets.chomp.split(',')
    non_numeric_input = true if capacity_array.select { |e| /[a-zA-Z]+/.match(e) }.length > 0
    capacity_array.map!(&:to_i)

    puts 'Enter starting capacities separated by comma:'
    starting_array = gets.chomp.split(',')
    non_numeric_input = true if starting_array.select { |e| /[a-zA-Z]+/.match(e) }.length > 0
    starting_array.map!(&:to_i)

    puts 'Enter ending capacities separated by comma:'
    ending_array = gets.chomp.split(',')
    non_numeric_input = true if ending_array.select { |e| /[a-zA-Z]+/.match(e) }.length > 0
    ending_array.map!(&:to_i)

    out_of_bounds = (0..capacity_array.length - 1).map do |i|
      starting_array[i] <= capacity_array[i] && ending_array[i] <= capacity_array[i] &&
        starting_array[i] >= 0 && ending_array[i] >= 0
    end.include? false
    constant_volume = starting_array.inject(:+) == ending_array.inject(:+)

    empty_arrays = capacity_array.length < 1 || starting_array.length < 1 || ending_array.length < 1

    if non_numeric_input || empty_arrays
      puts 'Invalid input'
      return
    elsif out_of_bounds
      puts 'Water level out of bounds'
      return
    elsif !constant_volume
      puts 'Starting and ending water levels do not add up!'
      return
    elsif [starting_array.length, ending_array.length, capacity_array.length].uniq.length > 1
      puts 'Number of jugs does not match'
      return
    end

    Node.const_set('Maxlevel', capacity_array)

    node_list = []
    puts "Checking if it is possible to get to final state\nThis may take a while..."
    build_graph(starting_array, node_list)
    possible = node_list.include? Node.new(ending_array, false)

    if possible
      puts "Attempting to find path with least number of steps.\nThis may take a while..."
      start_time = Time.now
      matrix = build_adjacency_matrix(node_list)
      paths = []
      self.all_paths = []
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

      if self.all_paths.length < 1
        puts 'Could not find the shortest path within given time'
      else
        end_time = Time.now
        puts "Found #{self.all_paths.length} paths in #{end_time - start_time} seconds"
        min_path = self.all_paths.min_by { |x| x.length }
        puts 'Follow these steps to reach final state'
        min_path.each { |e| puts node_list[e].level.to_s[1..-2] }
      end
    else
      puts 'Not possible to reach the final state'
    end
  end
end

if $0 == __FILE__
  raise ArgumentError, "Usage: #{$0}" unless ARGV.length == 0
  Calculator.new.calculate
end
