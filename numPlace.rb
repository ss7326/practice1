# 
# param [Array] grid 1から9の値か、nilが81個並んだ配列
# return [Array] 改行とスペース消した値を9×9のgrid
#
def print_grid(grid, pad="\n")
    print (0..8).map{ |i|
      grid[9*i, 9].map{ |v|
        (v || ".") }.join("") }.join(pad), "\n"
  end
  
  # 
  # param [String] string 1から9の値か、nilが81個並んだ一元配列
  # return [Array] .をnilに変換
  #
  def convert_dot_to_nil_lists(string)
    string.split(//).map{ |c| c == "." ? nil : c.to_i }
  end
  
  # 
  # param [Array] grid 
  # param [Integer] cn セル番号
  # return [Array] 該当する行に存在する値を配列としてを返す
  #
  def row(grid, cn)
    grid[9 * (cn / 9), 9]
  end
  
  # 
  # param [Array] grid 
  # param [Integer] cn セル番号
  # return [Array] 該当する列に存在する値を配列としてを返す
  #
  def column(grid, cn)
    (0..8).map{ |k| grid[9 * k + cn % 9] }
  end
  
  # 
  # param [Array] grid 
  # param [Integer] cn セル番号
  # return [Array] 該当する正方形に存在する値を配列としてを返す
  #
  def square(grid, cn)
    (0..8).map{ |k| grid[9*(3*(cn/9/3)+(k/3))+3*(cn%9/3)+(k%3)]}
  end
  
  # 
  # param [Array] grid 1から9の値か、`nil`が81個並んだ配列
  # return [Array] nil　になっている位置をインデックス番号にして配列として返す
  #
  def empty_cell_numbers(grid)
    (0..80).reject{ |p| grid[p] }
  end
  
  # 
  # param [Array] grid 
  # param [Integer] cell_number 
  # return [Array] 該当するセル番号の行、列、正方形に存在しない値を配列としてを返す
  #
  def possible_numbers(grid, cell_number)
    (1..9).to_a - fixed_numbers(grid, cell_number)
  end
  
  # 
  # param [Array] grid 
  # param [Integer] cell_number 
  # return [Array] 該当するセル番号の行、列、正方形に存在する値を配列としてを返す
  #
  def fixed_numbers(grid, cell_number)
    (
      row(grid, cell_number).compact |
      column(grid, cell_number).compact |
      square(grid, cell_number).compact
    )
  end
  
  # 
  # param [Array] grid
  # return [Array] grid 回答
  #
  def solve(grid)
    empty_cell_numbers = empty_cell_numbers(grid)
  
    candidates = empty_cell_numbers.map{ |cell_number|
      [cell_number, possible_numbers(grid, cell_number)]
    }
  
    ordered_candidates = candidates.sort_by{ |cell| cell[1].length }
  
    if ordered_candidates.empty?
      print "\e[31m"  # bash出力を赤色に
      puts 'complete↓'
      print "\e[0m"   # bash出力の色を元に戻す
      grid
    else
  
      p ordered_candidates[0]
  
      cell_number, candidate_values = ordered_candidates[0]
  
      candidate_values.each do |value|
        grid[cell_number] = value
  
        sleep(0.02)
        print_grid(grid)
        puts "残り#{grid.count(nil)}個"
        puts '---------'
        return grid if solve(grid)
      end
  
      p "grid[#{cell_number}] => #{grid[cell_number]} 取り消し"
      grid[cell_number] = nil  # 全て失敗したら未確定に戻す
      return false
    end
  end
  
  # 
  # return [ARGF] 数独を表示
  #
  ARGF.each do |line|
    remove_space_line = line.gsub(/\s/, '')
    value_or_nil_lists = convert_dot_to_nil_lists(remove_space_line)
    solved_lists = solve(value_or_nil_lists)
    print_grid(solved_lists)
  end