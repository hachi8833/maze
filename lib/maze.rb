#!/usr/bin/env ruby
# coding: utf-8

require 'pry'

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

class Point
  attr_reader :output

  def initialize(char)
    @output = char.freeze
  end

end

class Maze
  attr_accessor :x, :y, :array_2d
  attr_reader :road, :wall, :prewall

  def initialize(x, y)
    @x = x.freeze
    @y = y.freeze
    @road, @wall, @prewall = Point.new('　'),
                             Point.new('〓'),
                             Point.new('〓')
    @depth, @offset        = 1, 2
    @array_2d = prepare_maze(@x, @y)
  end

  def get_point(x, y)
    return @array_2d[x][y].output 
  end

  def set_point(x, y, point)
    @array_2d[x][y] = point
  end

  def output
    @array_2d.each do |line|
      # このc.outputはポリモーフィックになっているか?
      puts line.map {|c| c.output }.join
    end
  end

  def plot_maze(x, y)
    true
  end

  def build_maze
    binding.pry
    x = (@offset..(@x - @offset)).select { |dx| dx % 2 == 0 }
    y = (@offset..(@y - @offset)).select { |dy| dy % 2 == 0 }
    y.each do |yy|
      x.each do |xx|
        next if get_point(xx, yy) == @wall.output
        until plot_maze(xx, yy)
        end
      end
    end
  end

  private

  def prepare_maze(x, y)
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

