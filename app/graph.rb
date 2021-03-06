module Graph
  attr_accessor :all_paths

  def build_graph(start_point, node_list)
    # add start node to graph
    # find adjacent nodes
    # check if adjacent nodes are already in graph
    # if all nodes already in graph then terminate
    # else build graph for nodes which are not in graph

    start_node = Node.new(start_point)
    node_list.push(start_node)
    nodes = start_node.neighbours.reject { |e| node_list.include? Node.new(e, false) }
    nodes.each { |e| build_graph(e, node_list) }
  end

  def build_adjacency_matrix(nodes)
    matrix = Array.new(nodes.length) { Array.new(nodes.length) }
    (0..nodes.length - 1).each do |i|
      (0..nodes.length - 1).each do |j|
        matrix[i][j] = 0
        next if i == j
        if nodes[i].neighbours.include? nodes[j].level
          matrix[i][j] = 1
        end
      end
    end
    matrix
  end

  def find_path(matrix, start_index, end_index, visited, path, start_time)
    visited[start_index] = true
    path.push(start_index)
    found = if start_index == end_index
      self.all_paths.push(path.dup) unless self.all_paths.include? path
    else
      neighbours = matrix[start_index].each_with_index.map { |e, i| i if e == 1 }.compact
      neighbours.each do |i|
        find_path(matrix, i, end_index, visited, path, start_time) if !visited[i]
      end
    end
    return if (Time.now - start_time) > 300 || self.all_paths.length > 2500

    path.pop
    visited[start_index] = false
  end
end
