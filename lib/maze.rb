#!/usr/bin/env ruby
# coding: utf-8

#= 迷路自動作成ライブラリ
# 「壁伸ばし法」に基づく
# 参考: http://aanda.system.to/maze/wmaze.txt

# x, y = 31, 41
#
# x += 1 if x.even?
# y += 1 if y.even?
# maze = Maze.new(x, y)
# maze.plotmaze
# maze.output

# 壁/床の種別を表すクラス。@ouptputをポリモーフィックに使用する
class Point
  attr_reader :output

  def initialize(char)
    @output = char.freeze
  end

end

#メインのクラス
class Maze
  attr_accessor :x, :y, :array_2d
  attr_reader :road, :wall, :prewall

  #初期化
  def initialize(x, y)
    x += 1 if x.even?
    y += 1 if y.even?
    @x = x.freeze
    @y = y.freeze
    @road, @wall, @prewall = Point.new('　'),
                             Point.new('〓'),
                             Point.new('$$')
    @depth, @offset        = 1, 2
    @array_2d = initialize_array(@x, @y)
  end

  #配列の点を取得
  def get_point(x, y)
    return @array_2d[x][y]
  end

  #配列に点を設定
  def set_point(x, y, point)
    @array_2d[x][y] = point
  end

  #配列を出力
  def output
    @array_2d.each do |line|
      # このc.outputはポリモーフィックになっているか?
      puts line.map {|c| c.output }.join
    end
  end

  #壁を1つ作成可能なところまでランダムに伸ばす
  def plot_maze(x, y)
    rnd = rand(0..3) #最初の方向をランダムに決める

    direction = [0, 1, 2, 3]
    4.times do |i|
      case direction[rnd - i] #4方向を順繰りに処理
      when 0
        dx, dy = 0, -1
      when 1
        dx, dy = -1, 0
      when 2
        dx, dy = 0, 1
      when 3
        dx, dy = 1, 0
      end
    
      case get_point(x + (dx * @offset), y + (dy * @offset))
      when @wall
        # 壁にぶつかったら壁までつないで戻る
        set_point(x, y, @wall)
        set_point(x + dx, y + dy, @wall)
        return true
      when @road
        # 行き先が道ならprewallをその方向に伸ばす
        set_point(x, y, @prewall)
        set_point(x + dx, y + dy, @prewall)

        # 再帰
        if plot_maze(x + (dx * @offset), y + (dy * @offset))
          # 戻る時にprewallをwallに変更
          set_point(x, y, @wall)
          set_point(x + dx, y + dy, @wall)
          return true
        else
          # エラーで戻ったらprewallをroadに戻してやり直す
          set_point(x, y, @road)
          set_point(x + dx, y + dy, @road)
          return false
        end
      end
    end
  end

  #配列の偶数点をトラバースしてplot_mazeを呼び出す
  def build_maze
    even_x = (@offset..(@x - @offset)).select { |dx| dx % 2 == 0 }
    even_y = (@offset..(@y - @offset)).select { |dy| dy % 2 == 0 }
    even_y.each do |y|
      even_x.each do |x|
        next if get_point(x, y) == @wall
        until plot_maze(x, y)
        end
      end
    end
  end

  private

  #配列の初期化
  def initialize_array(x, y)
    array, line = [], []

    #最初の行
    array << [@wall] * y

    #途中の行
    line << @wall
    (y - (@depth * 2)).times { line << @road }
    line << @wall
    (x - (@depth * 2)).times { array << line.dup }

    #最後の行
    array << [@wall] * y

    return array
  end
end

