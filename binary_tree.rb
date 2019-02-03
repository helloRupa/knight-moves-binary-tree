class Node
  attr_accessor :parent, :left_child, :right_child
  attr_reader :value

  def initialize(val)
    @value = val
    @parent = nil
    @left_child = nil
    @right_child = nil
  end
end

class Tree
  attr_reader :root

  def initialize(arr)
    @root = nil
    # build_tree_from_unsorted(arr)
    build_tree_from_sorted(arr)
    # build_tree_arbitrary(arr)
  end

  # Build an unbalanced tree from unsorted data
  def build_tree_from_unsorted(arr)
    return nil if arr.empty?
    @root = Node.new(arr.shift)

    until arr.empty?
      child_node = Node.new(arr.shift)
      assign_children(@root, child_node)
    end
  end

  def assign_children(parent_node, child_node)
    loop do
      side_attr = child_node.value < parent_node.value ? :@left_child : :@right_child
      parent_node = set_single_child_parent(parent_node, child_node, side_attr)
      return if parent_node.nil?
    end
  end

  def set_single_child_parent(parent_node, child_node, side_attr)
    if parent_node.instance_variable_get(side_attr).nil?
      parent_node.instance_variable_set(side_attr, child_node)
      child_node.parent = parent_node
      nil
    else
      parent_node.instance_variable_get(side_attr)
    end
  end

  # Build a tree from sorted data, setting the median as the root
  def build_tree_from_sorted(arr)
    return nil if arr.empty?
    left, right, middle = get_left_right_middle(arr)
    @root = Node.new(middle)
    make_children(@root, left)
    make_children(@root, right)
  end

  def get_left_right_middle(arr)
    middle = arr.length / 2
    left = arr[0...middle]
    right = arr[middle + 1..-1]
    [left, right, arr[middle]]
  end

  def make_children(parent, arr)
    return if arr.empty?
    left, right, middle = get_left_right_middle(arr)
    child = Node.new(middle)
    child.parent = parent
    if middle < parent.value
      parent.left_child = child
    else
      parent.right_child = child
    end
    make_children(child, left)
    make_children(child, right)
  end

  # Build a meaningless tree and waste your time
  def build_tree_arbitrary(arr)
    node = Node.new(arr[0])
    queue = [node]
    @root = node
    i = 0

    until queue.empty?
      node = queue.shift
      children = node_children(node, i, arr)
      queue.concat(children)
      i += 2
    end
  end

  def node_children(node, idx, arr)
    left_child = idx + 1 < arr.length ? Node.new(arr[idx + 1]) : nil
    right_child = idx + 2 < arr.length ? Node.new(arr[idx + 2]) : nil
    set_child_parent(left_child, node, :@left_child)
    set_child_parent(right_child, node, :@right_child)
    [left_child, right_child].reject(&:nil?)
  end

  def set_child_parent(child_node, parent_node, side_attr)
    return nil if child_node.nil?
    child_node.parent = parent_node
    parent_node.instance_variable_set(side_attr, child_node)
  end

  def print_tree
    puts 'Empty' if @root.nil?
    nodes = [@root]

    until nodes.all?(&:nil?)
      print_layer(nodes)
      nodes = get_next_layer(nodes)
    end
  end

  def print_layer(nodes)
    node_str = nodes.reduce('') do |str, node|
      str + (node.nil? ? " X" : " #{node.value}")
    end
    puts node_str
  end

  def get_next_layer(nodes)
    nodes.reject(&:nil?).reduce([]) do |next_nodes, node|
      next_nodes.concat([node.left_child, node.right_child])
    end
  end

  def get_next_nodes(node)
    get_next_layer([node]).reject(&:nil?)
  end

  def bfs(target)
    node = @root
    queue = [node]

    until queue.empty?
      node = queue.shift
      return node if node.value == target
      queue.concat(get_next_nodes(node))
    end
    nil
  end

  def dfs(target)
    node = @root
    stack = [node]

    until stack.empty?
      node = stack.pop
      return node if node.value == target
      stack.concat(get_next_nodes(node))
    end
    nil
  end

  def dfs_rec(target, node = @root)
    return nil if node.nil?
    return node if node.value == target
    dfs_rec(target, node.left_child)
    dfs_rec(target, node.right_child)
  end
end

arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# arr = [20, 8, 3, 6, 20, 7, 10, 12]
tree = Tree.new(arr)
tree.print_tree
puts '50'
p tree.dfs_rec(50)
puts '10'
p tree.dfs_rec(10)
# puts '20'
# p tree.dfs_rec(20)
# puts '3'
# p tree.dfs_rec(3)
# p tree.root.value
