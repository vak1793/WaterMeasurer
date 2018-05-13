require 'spec_helper'
require_relative '../app/calculator'
require_relative '../app/node'
require_relative '../app/graph'

RSpec.describe Calculator do
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
    fake.string
  end

  let(:calculator_object) { Calculator.new }

  describe '#calculate' do
    context 'when input is non numeric' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,0,c', '8,8,0', '4,4,4')
      end

      it "displays a message saying 'Invalid input'" do
        expect(output).to include('Invalid input')
      end
    end

    context 'when input is out of bounds' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,0,0', '8,8,0', '4,4,4')
      end

      it "displays a message saying 'Water level out of bounds'" do
        expect(output).to include('Water level out of bounds')
      end
    end

    context 'when number of jugs in inputs do not match' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,5,3', '8,2,0,1', '8,2,0,1')
      end

      it "displays a message saying 'Number of jugs does not match'" do
        expect(output).to include('Number of jugs does not match')
      end
    end

    context 'when initial level and final level do not match' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,5,3', '8,0,0', '8,4,0')
      end

      it "displays a message saying 'Starting and ending water levels do not add up!'" do
        expect(output).to include('Starting and ending water levels do not add up!')
      end
    end

    context 'when it is not possible to get to final configuration' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,8,8', '8,0,0', '7,1,0')
      end

      it "displays a message saying 'Not possible to reach the final state'" do
        expect(output).to include('Not possible to reach the final state')
      end
    end

    context 'when it is possible to get to final configuration' do
      let(:output) { capture_stdout { calculator_object.calculate } }
      before do
        allow(calculator_object)
          .to receive(:gets)
          .and_return('8,5,3', '8,0,0', '4,4,0')
      end

      it "displays the steps to reach the final configuration" do
        expect(output).to include('Follow these steps to reach final state')
      end
    end
  end
end
