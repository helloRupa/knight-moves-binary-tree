class Space
  attr_reader :coords
  attr_accessor :parent, :children

  def initialize(coords)
    @coords = coords
    @parent = nil
    @children = []
  end
end

class Board
  def self.on_board?(coords)
    y, x = coords
    y.between?(0, 7) && x.between?(0, 7)
  end
end

class KnightMoves
  MOVES = [[2, 1], [2, -1], [1, 2], [1, -2], [-2, 1], [-2, -1], [-1, 2], [-1, -2]].freeze

  def initialize(start)
    @root = Space.new(start)
    @target = nil
    @target_node = nil
  end

  def find_path(target)
    @target = target
    build_tree_to_target
    p dfs_path(@root)
    p target_to_root_path
  end

  private

  def next_moves(coords)
    y, x = coords
    MOVES.each_with_object([]) do |adds, moves|
      move = [adds[0] + y, adds[1] + x]
      moves << move if Board.on_board?(move)
    end
  end

  def make_children(node)
    parent_coords = node.coords
    child_coords = next_moves(parent_coords)
    child_coords.each do |coords|
      next if parent_coords == coords
      child = Space.new(coords)
      child.parent = node
      node.children << child
    end
  end

  def uniq_children(node, visited)
    node.children.reject { |child| visited.include?(child.coords) }
  end

  # Build tree breadth_first, stop at target
  def build_tree_to_target
    node = @root
    queue = []
    visited = []

    until node.coords == @target
      visited << node.coords
      make_children(node)
      queue.concat(uniq_children(node, visited))
      node = queue.shift
    end
    @target_node = node
  end

  # Since BFS was used to build tree to target, DFS will find shortest path
  def dfs_path(node, path = [])
    coords = node.coords
    path << coords

    return path if coords == @target

    node.children.each do |child|
      res = dfs_path(child, path.dup)
      return res unless res.nil?
    end
    nil
  end

  # Or just plot from target_node to root
  def target_to_root_path
    node = @target_node
    path = [node.coords]

    until node.parent.nil?
      node = node.parent
      path.unshift(node.coords)
    end
    path
  end
end

knight = KnightMoves.new([0, 0])
knight.find_path([7, 7])
