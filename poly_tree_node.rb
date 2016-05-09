class PolyTreeNode
  attr_reader :value

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def parent=(new_parent)
    old_parent = self.parent
    if old_parent != nil
      if old_parent.children.include?(self)
        old_parent.children.delete(self)
      end
    end

    @parent = new_parent

    if @parent != nil
      unless @parent.children.include?(self)
        @parent.children << self
      end
    end
  end

  def remove_child(child)
    raise "Error found!" if child.parent != self
    child.parent = nil
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def inspect
    unless @parent.nil?
      { 'value' => @value, 'parent_val' => @parent.value, 'children' => @children }.inspect
    else
      { 'value' => @value, 'parent_val' => nil, 'children' => @children }.inspect
    end
  end

  def dfs(target_value)
    return self if self.value == target_value
    self.children.each do |child|
      result = child.dfs(target_value)
      return result unless result.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      curr_node = queue.shift
      if curr_node.value == target_value
        return curr_node
      end
      queue += curr_node.children
    end
    nil
  end
end
