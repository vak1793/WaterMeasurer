class Node
  attr_accessor :level, :neighbours

  def initialize(initial_level, calculate_neighbours = true)
    @level = initial_level
    @neighbours = find_neighbours if calculate_neighbours
  end

  def eql?(other)
    level == other.level
  end

  def ==(other)
    level == other.level
  end

  private

  def find_neighbours
    n = []
    len = level.length

    (0..(len - 1)).each do |i|
      (0..(len - 1)).each do |j|
        next if i == j
        temp = level.dup
        if temp[j] + temp[i] >= Maxlevel[j]
          temp[i] = temp[i] + temp[j] - Maxlevel[j]
          temp[j] = Maxlevel[j]
        else
          temp[j] += temp[i]
          temp[i] = 0
        end
        n.push(temp) unless n.include? temp
      end
    end
    n.delete(level)

    return n
  end
end
