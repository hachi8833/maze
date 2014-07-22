#!/usr/bin/env ruby
# coding: utf-8

# 参考: http://aanda.system.to/maze/wmaze.txt
require 'pry'
class Maze

  attr_accessor :x, :y, :ary
  MARGIN = 1
  OFFSET = 3
  INCR   = 2
  ROAD, WALL, PREWALL = nil, 1, 2

  def initialize(x, y)
    @x, @y = x, y
    @ary = prepare_ary(x, y)
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

    (MARGIN..(@x - 2)).each do |i|
      setpoint(i, 1, WALL)
      setpoint(i, @y - 2, WALL)
    end 

    (MARGIN..(@y - 2)).each do |j|
      setpoint(1, j, WALL)
      setpoint(@x - 2, j, WALL)
    end 
  end

  def getpoint(x, y)
    @ary[x][y]
  end

  def setpoint(x, y, piece)
    @ary[x][y] = piece
  end

  def maze_sub(x, y)
    rnd = rand(0..3)
    pol = 1 # 回転の向き

    4.times do |cnt| # 方向転換の回数

      puts "rnd: #{rnd}, cnt: #{cnt}, pol: #{pol}"
      puts "(rnd + (cnt * pol) + 4) % 4 : #{(rnd + (cnt * pol) + 4) % 4 }"
      case (rnd + (cnt * pol) + 4) % 4
      when 0
        px, py = 0, -1
      when 1
        px, py = -1, 0
      when 2
        px, py = 0, 1
      when 3
        px, py = 1, 0
      end

      # 壁にぶつかったら処理を完了して戻る
      if getpoint(x + (px * 2), y + (py * 2)) == WALL
        setpoint(x, y, WALL)
        setpoint(x + px, y + py, WALL) 
        return true 
      end

      # 行き先が道なら「作りかけの壁」をその方向に伸ばす
      if getpoint(x + (px * 2), y + (py * 2)) == ROAD
        setpoint(x, y, PREWALL)
        setpoint(x + px, y + py, PREWALL) 

        #再帰
        if maze_sub(x + (px * 2), y + (py * 2))
          #戻った時に「作りかけの壁」を完成した壁に変える
          setpoint(x, y, WALL)
          setpoint(x + px, y + py, WALL)
          return true
        else
          #エラーで戻ったら「作りかけの壁」を道に戻す
          setpoint(x, y, ROAD)
          setpoint(x + px, y + py, ROAD)
          return false
        end 
      end
    end
    #4方向とも「作りかけの壁」ならエラーで戻る
    return false
  end

  def plotmaze
    (OFFSET..(@y - 3)).each do |i|
      (OFFSET..(@x - 3)).each do |j|
        puts "i: #{i}, j: #{j}"
        if getpoint(i, j) == ROAD
          # binding.pry
          # while maze_sub(i, j) do

          # end
        end
        j += INCR
      end 
      i += INCR
    end
  end

  def output
    @ary.each do |i|
      i.each do |j|
        case j
        when WALL
          print "*"
        when PREWALL
          print "*"
        else
          print " "
        end
      end
      print "\n"
    end
  end
end

maze = Maze.new(9, 9)
maze.init_ary(9, 9)
maze.plotmaze
maze.output
