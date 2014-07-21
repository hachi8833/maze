#!/usr/bin/env ruby
# coding: utf-8

# 一般に、外壁で囲まれマス目で構成される長方形の迷路の辺がx, yのとき
# 外壁を含む面積はxy
# 外壁を含まない面積は(x-2)(y-2)
# 内壁の面積は (x-3)(y-3)/2
# 道の面積は(x-2)(y-2) - 2*(x-3)(y-3)
# ただし、迷路には閉じた道がなく、すべての内壁は外壁に接している(島がない)とする
# (島がある場合は内壁の面積は奇数になるが、ここでは考慮しない)

require 'pry'
class Maze
  attr_accessor :x, :y, :len, :ary, :limit, :prev
  DIR = [:n, :e, :s, :w] # 方角
  STEP, OFFSET = 1, 2
  WALL, PARTITION, ROAD = 1, 1, nil

  #インスタンス変数の初期化
  def initialize(x, y)
    @x, @y = (x * 2) + 1, (y * 2) + 1 #奇数化
    print "@x: #{@x}, @y: #{@y}\n"
    @limit = (@x - 3) * (@y - 3) / 2 #作成可能な内壁の総数
    @len = (@x < @y ? @x : @y) - 2 #一回に作る壁の長さを制限
    @ary = prepare_ary(@x, @y)
    @prev = nil #直前の向き
  end

  # 迷路の配列を確保
  def prepare_ary(x, y)
    ary, tmp = [], []

    #最初の行
    ary << [WALL] * x

    #途中の行
    tmp << WALL
    (x - 2).times { tmp << ROAD }
    tmp << WALL
    (y - 2).times {ary << tmp.dup }

    #最後の行
    ary << [WALL] * x
    return ary
  end

 # 壁を1つ置く 
  def plot(x, y)
    puts "plot: x: #{x}, y: #{y}"
    @ary[y][x] = WALL
    self.output
  end

  # 壁をランダムに置く
  def random
    loop do
      x = rand(2..((@x - 3)/2)) * 2
      y = rand(2..((@y - 3)/2)) * 2
      return x, y if room?(x, y)
    end
  end

  # 判定1: 現在位置に壁を置けるか
  def room?(x, y)
    print "x: #{x}, y: #{y} "
    if @ary[y][x] == ROAD
      puts 'judge success'
      true
    else
      puts 'judge failure'
      false
    end
  end

  # 判定2: 前左右に進めるか
  def way?(x, y, dir)
    case dir
    when :n
      return true if north(x, y) || east(x, y) || west(x, y)
    when :e
      return true if east(x, y) || north(x, y) || south(x, y)
    when :s
      return true if south(x, y) || east(x, y) || west(x, y)
    when :w
      return true if west(x, y) || north(x, y) || south(x, y)
    end
  end

  # 判定3: 進む先は外壁か
  def outerwall?(i, j)
    return true if i == 0 || i == @x - 1 || j == 0 || j == @y - 1
  end

  # 判定4: 前回の向きと逆走しているか
  def back?(dir)
    return false unless @prev
    if (dir == :n and @prev == :s) ||
       (dir == :s and @prev == :n) ||
       (dir == :e and @prev == :w) ||
       (dir == :w and @prev == :e)
      return true 
    end
  end

  # 判定5: 座標が内壁内にあるか
  def inner?(x, y)
    if ( x > ( OFFSET - 1 )) &&
       ( x < ( @x - OFFSET )) && 
       ( y > ( OFFSET - 1 )) &&
       ( y < ( @y - OFFSET )) then
      return true
    else
      return false
    end
  end
  
  # 判定6: 進む先は内壁か
  def innerwall?(i, j)
    if (@ary[j][i] == PARTITION) && inner?(i, j)
      puts 'partition found'
      true
    else
      false
    end
  end

  def north(x, y)
    y -= STEP
    return x, y 
  end

  def east(x, y)
    x += STEP
    return x, y
  end

  def south(x, y)
    y += STEP
    return x, y 
  end
  
  def west(x, y)
    x -= STEP
    return x, y 
  end

  # 進んだ先の座標を取得
  def forward(x, y, dir)
    case dir
    when :n
      x, y = north(x, y)
    when :e
      x, y = east(x, y)
    when :s
      x, y = south(x, y)
    when :w
      x, y = west(x, y)
    end
    return x, y
  end

  # 方角をランダムに決め、逆走防止
  def fortune(x, y)
   loop do
     dir = DIR[rand(0..3)]
     x, y = forward(x, y, dir)
     puts "fortune: x: #{x}, y: #{y}, dir: #{dir}"
     return dir unless back?(dir)
   end 
  end

  # 指定の方向に1STEP進み、プロットして座標を返す
  def plotforward(x, y, dir)
    puts "plotforward: x: #{x} y: #{y}"
    x, y = forward(x, y, dir)
    plot(x, y)
    return x, y
  end

  # 内壁を1本作成
  def plotline
    len = @len
    x, y = random
    plot(x, y)
    
    loop do
      dir = fortune(x, y)
      
      fx, fy = forward(x, y, dir)
      fx, fy = forward(fx, fy, dir)
      if outerwall?(fx, fy) # 2つ先に外壁があればぶつかって終わる
        x, y = plotforward(x, y, dir)
        return
      else
        if innerwall?(fx, fy)
          next
        else
          unless way?(x, y, dir) # 左右に進めなければ終わる
            return
          else #2歩進む
            x, y = plotforward(x, y, dir)
            x, y = plotforward(x, y, dir)
            len -= 2
            @prev = dir
            puts "@prev: #{@prev}"
          end
          return if len <= 0
        end
      end
    end
  end

  # 迷路を作成
  def plotmaze
    plotline
  end

  # 迷路を出力
  def output
    @ary.each do |i|
      i.each do |j|
        case j
        when WALL
          print "*"
        when PARTITION
          print "*"
        else
          print " "
        end
      end
      print "\n"
    end
  end

end

# メイン
maze = Maze.new(10,5)
maze.plotmaze
maze.output
