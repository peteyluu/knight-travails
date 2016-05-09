require_relative 'poly_tree_node'

class KnightPathTravails
  attr_reader :start_pos

  MOVES = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_pos = [start_pos]
    @tree_coords = Hash.new { |h, k| h[k] = [] }
    build_move_tree
  end

  def build_tree_coords
    @parent_pos = start_pos
    temp_moves = new_move_pos(@parent_pos)
    @tree_coords[@parent_pos] += temp_moves
    values = @tree_coords[@parent_pos]
    queue = deep_dup(values)
    until queue.empty?
      @parent_pos = queue.shift
      temp_moves = new_move_pos(@parent_pos)
      @tree_coords[@parent_pos] += temp_moves
      values = @tree_coords[@parent_pos]
      queue += deep_dup(values)
    end
  end

  def build_move_tree
    @root_node = PolyTreeNode.new(start_pos)
    nodes = [@root_node]
    until nodes.empty?
      curr_node = nodes.shift
      curr_pos = curr_node.value
      new_move_pos(curr_pos).each do |next_pos|
        next_node = PolyTreeNode.new(next_pos)
        curr_node.add_child(next_node)
        nodes << next_node
      end
    end
  end

  def find_path(end_pos)
    end_node = @root_node.bfs(end_pos)
    trace_path_back(end_node).map(&:value).reverse
  end

  def trace_path_back(end_node)
    nodes = []
    curr_node = end_node
    until curr_node.nil?
      nodes << curr_node
      curr_node = curr_node.parent
    end
    nodes
  end

  def new_move_pos(pos)
    new_moves = valid_moves(pos)
    result_moves = []
    new_moves.each do |move|
      if !@visited_pos.include?(move)
        @visited_pos << move
        result_moves << move
      end
    end
    result_moves
  end

  def valid_moves(pos)
    moves = []
    MOVES.each do |dx, dy|
      curr_move = [pos[0] + dx, pos[1] + dy]
      moves << curr_move if in_bounds?(curr_move)
    end
    moves
  end

  def in_bounds?(pos)
    row_i, col_i = pos
    row_i.between?(0, 8) && col_i.between?(0, 8)
  end

  private

  def deep_dup(array)
    a = []
    array.each do |el|
      if el.is_a?(Array)
        a << deep_dup(el)
      else
        a << el
      end
    end
    a
  end
end

if __FILE__ == $PROGRAM_NAME
  kpt = KnightPathTravails.new([0, 0])
  p kpt.find_path([6, 2])
end
