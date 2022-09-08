class Node
  include Comparable

  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(0, @array.length - 1)
  end

  def build_tree(start, end_of)
    #base case, when start and end cross stop recursion
    if start > end_of
      return nil
    end
    #get middle of array and make the root node with mid
    mid = (start + end_of)/2
    root = Node.new(@array[mid])
    #recursively make the left tree and assign it to the left child
    root.left = build_tree(start, mid - 1)
    #recursively make the right tree and assign it to the right child
    root.right = build_tree(mid + 1, end_of)

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    if value > node.data
      if node.right == nil
        node.right = Node.new(value)
      else
        insert(value, node.right)
      end
    elsif value < node.data
      if node.left == nil
        node.left = Node.new(value)
      else
        insert(value, node.left)
      end
    end
  end

  def delete(value, node = @root)
    if node == nil
      return node
    end
    if value > node.data
      node.right = delete(value, node.right)
    elsif value < node.data
      node.left = delete(value, node.left)
    #if node value matches the value to delete
    else 
      #returns branch without deleted node if one branch or both are nil
      if node.right == nil
        return node.left
      elsif node.left == nil
        return node.right
      end
      #node value to be deleted has two values
      node.data = find_min(node.right)
      node.right = delete(node.data, node.right)
    end
    node
  end

  def find_min(node)
    node
    while node.left != nil
      node = node.left
    end
    min = node.data
  end

  def find(value, root = @root)
    if root == nil
      puts "Node with this value doesn't exist"
      return
    elsif root.data == value
      return root
    elsif value > root.data
      find(value, root.right)
    else value < root.data
      find(value, root.left)
    end
  end

  def level_order(queue = [], arr = [], root = @root, &block)
    if block_given?
      block.call(root)
    end
    arr.push(root.data)
    queue.push(root.left) unless root.left == nil
    queue.push(root.right) unless root.right == nil
    level_order(queue, arr, queue.shift, &block) unless queue.length == 0
    arr
  end

  def level_order_iterate(queue = [], arr = [], root = @root)
    queue.push(root)
    while queue.length != 0
      root = queue.shift
      if block_given?
        yield(root)
      end
      arr.push(root.data)
      queue.push(root.left) unless root.left == nil
      queue.push(root.right) unless root.right == nil
    end
    arr
  end

  def preorder(root = @root, arr = [], &block)
    if block_given?
      block.call(root)
    end
    arr.push(root.data)
    inorder(root.left, arr, &block)unless root.left == nil
    inorder(root.right, arr, &block) unless root.right == nil
    arr
  end

  def inorder (root = @root, arr = [], &block)
    inorder(root.left, arr, &block)unless root.left == nil
    if block_given?
      block.call(root)
    end
    arr.push(root.data)
    inorder(root.right, arr, &block) unless root.right == nil
    arr
  end

  def postorder(root = @root, arr = [], &block)
    inorder(root.left, arr, &block)unless root.left == nil
    inorder(root.right, arr, &block) unless root.right == nil
    if block_given?
      block.call(root)
    end
    arr.push(root.data)
  end

  def height(node)
    #0 height if node has no children or node is nil
    if node == nil || (node.right == nil && node.left == nil)
      return 0
    end
    #recursively take the height of left and right node, choose the higher.
    # increment one for every level you go up starting from lowest leaf
    left_max = height(node.left)
    right_max = height(node.right) 
    [left_max, right_max].max + 1
  end

  def depth(node)
    count = 0
    #start at root to look for node
    root = @root
    while true
      if root == nil || node == nil
        return "node not in tree"
      #go left if
      elsif node.data < root.data
        root = root.left
        count += 1
      #go right
      elsif node.data > root.data
        root = root.right
        count += 1
        #return count if a match
      else
        return count
      end
    end
  end




end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

tree.insert(26)
tree.pretty_print
tree.delete(67)
tree.pretty_print
puts tree.find(5)
p tree.postorder {|node| node.data += 1}
tree.pretty_print
puts tree.height(tree.find(6))
puts tree.depth(tree.find(9))