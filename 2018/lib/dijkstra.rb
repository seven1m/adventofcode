# ported and modified from https://gist.github.com/econchick/4666413

require 'set'

class Graph
  def initialize
    @nodes = Set.new
    @edges = {}
    @distances = {}
  end

  attr_reader :nodes, :edges, :distances

  def add_node(value)
    @nodes << value
  end

  def add_edge(from_node, to_node, distance)
    @edges[from_node] ||= []
    @edges[from_node] << to_node
    @edges[to_node] ||= []
    @edges[to_node] << from_node
    @distances[[from_node, to_node]] = distance
    @distances[[to_node, from_node]] = distance
  end

  def dijkstra(initial)
    visited = { initial => 0 }
    path = {}

    nodes = Set.new(@nodes)

    while nodes.any?
      min_node = nil
      nodes.each do |node|
        if visited.include?(node)
          if min_node.nil?
            min_node = node
          elsif visited[node] < visited[min_node]
            min_node = node
          end
        end
      end

      break if min_node.nil?

      nodes.delete(min_node)
      current_weight = visited[min_node]

      (@edges[min_node] || []).each do |edge|
        weight = current_weight + @distances[[min_node, edge]]
        if !visited.include?(edge) || weight < visited[edge]
          visited[edge] = weight
          path[edge] = min_node
        end
      end
    end

    [visited, path]
  end
end
