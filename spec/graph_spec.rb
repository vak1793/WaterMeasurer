require 'spec_helper'
require_relative '../app/node'
require_relative '../app/graph'

RSpec.describe Graph do
  let(:test_class) { Class.new { include Graph }.new }
  let(:node_list) { [] }
  let(:start_point) { [8,0,0] }
  let(:expected_graph) do
    [
      Node.new([8, 0, 0]),
      Node.new([3, 5, 0]),
      Node.new([0, 5, 3]),
      Node.new([5, 0, 3]),
      Node.new([5, 3, 0]),
      Node.new([2, 3, 3]),
      Node.new([2, 5, 1]),
      Node.new([7, 0, 1]),
      Node.new([7, 1, 0]),
      Node.new([4, 1, 3]),
      Node.new([4, 4, 0]),
      Node.new([1, 4, 3]),
      Node.new([1, 5, 2]),
      Node.new([6, 0, 2]),
      Node.new([6, 2, 0]),
      Node.new([3, 2, 3]),
      Node.new([3, 2, 3]),
      Node.new([5, 0, 3])
    ]
  end

  before(:all) do
    Node.const_set('Maxlevel', [8, 5, 3])
  end

  describe '#build_graph' do
    before do
      test_class.build_graph(start_point, node_list)
    end

    it 'builds a network of possible jug states' do
      expect(node_list).to eq(expected_graph)
    end
  end

  describe '#build_adjacency_matrix' do
    let(:actual) { test_class.build_adjacency_matrix(expected_graph) }
    let(:expected) do
      [
        [0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
        [0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [0, 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1],
        [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0],
        [1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0],
        [0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
        [0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]
    end

    it 'calculates the adjacency matrix for the list' do
      expect(actual).to eq(expected)
    end
  end
end
