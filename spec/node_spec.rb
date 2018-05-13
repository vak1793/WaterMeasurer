require 'spec_helper'
require_relative '../app/node'

RSpec.describe Node do
  describe '#find_neighbours' do
    let(:maxlevel) { [8, 5, 3] }
    let(:node) { Node.new([4, 2, 2]) }
    let(:expected_neighbours) do
      [
        [1, 5, 2],
        [3, 2, 3],
        [6, 0, 2],
        [4, 1, 3],
        [6, 2, 0],
        [4, 4, 0]
      ]
    end
    let(:actual_neighbours) { node.neighbours }

    before do
      stub_const('Maxlevel', maxlevel)
    end

    it 'finds the neighbouring nodes' do
      expect(actual_neighbours - expected_neighbours).to eq([])
    end
  end
end
