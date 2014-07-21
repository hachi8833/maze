#!/usr/bin/env ruby
# coding: utf-8

# 参考: http://aanda.system.to/maze/wmaze.txt

class Maze

  attr_accessor :x, :y, :ary
  MARGIN = 1
  OFFSET = 3
  INCR   = 2
  ROAD, WALL = nil, 1

  def initialize(x, y)
    @x, @y = x, y
    @ary = prepare_ary(x, y)
    init_ary(x, y)
  end

  def prepare_ary(x, y)
    ary, tmp = [], []

    #最初の行
    ary << [WALL] * y

    #途中の行
    tmp << WALL
    (y - 2).times { tmp << ROAD }
    tmp << WALL
    (x - 2).times {ary << tmp.dup }

    #最後の行
    ary << [WALL] * y

    
    return ary
  end

  def init_ary(x, y)
    x.times do |i|
      y.times do |j|
        setpoint(i, j, ROAD)
      end
    end
   
    (MARGIN..(@x - 1)).each do |i|
      setpoint(i, 1, WALL)
      setpoint(i, @y - 2, WALL)
    end 

    (MARGIN..(@y - 1)).each do |j|
      setpoint(1, j, WALL)
      setpoint(@x - 2, j, WALL)
    end 
  end

  def getpoint(x, y)
    @ary[x][y]
  end

  def setpoint(x, y, piece)
    puts "x: #{x}, y: #{y}"
    @ary[x][y] = piece
  end

  def plotmaze
    (OFFSET..(@y - 3)).each do |i|
      i += INCR
      (OFFSET..(@x - 3)).each do |j|
       j += INCR
        while maze_sub do

        end
      end 
    end
  end
end

