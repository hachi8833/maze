#!/usr/bin/env ruby
# coding: utf-8

#= 迷路自動作成ライブラリ
# 「壁伸ばし法」に基づく
# 参考: http://aanda.system.to/maze/wmaze.txt
#== 使用例 (main.rbより)
# x, y = 31, 41
#
# x += 1 if x.even?
# y += 1 if y.even?
# maze = Maze.new(x, y)
# maze.plotmaze
# maze.output

class Point
  attr_accessor :point

  def initialize(char)
    @point = char 
  end

  def output
    print @point
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
    @depth, @offset        = 1.freeze,
                             2.freeze
    @array_2d = prepare_maze(@x, @y)
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

