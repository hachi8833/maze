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
  attr_accessor :x, :y, :len, :ary, :plot
  N, E, S, W = 1, 2, 3, 4 # 方角
  STEP, OFFSET = 1, 2
  WALL, PARTITION, ROAD = 1, 1, nil

  #インスタンス変数の初期化
  def initialize(x, y)
    @x, @y = (x * 2) + 1, (y * 2) + 1 #奇数化
    print "@x: #{@x}, @y: #{@y}\n"
    @limit = (@x - 3) * (@y - 3) / 2 #作成可能な内壁の総数
    @len = (@x < @y ? @x : @y) / 2 #一回に作る壁の長さを制限
    @ary = prepare_ary(@x, @y)
    @prev = nil #直前の座標
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

  #内壁が埋まるまで壁をランダムに設置
  def plotrandom
    loop do
      x = rand(2..((@x-3)/2)) * 2
      y = rand(2..((@y-3)/2)) * 2
      if judge(x, y)
        return x, y
      else
        # ここをどうするか
      end
    end
  end

  # 既に壁があるかどうかを判断
  def judge(x, y)
    print "x: #{x}, y: #{y} "
    if @ary[y][x] == ROAD
      puts 'judge success'
      true
    else
      puts 'judge failure'
      false
    end
  end

 # 壁を1つ置く 
  def plot(x, y)
    @ary[y][x] = WALL
    self.output
  end

  #方角を決める。逆走はしない
  def fortune(x,y)
    loop do
      dir = rand(1..4)
      case dir
      when N
        y -= OFFSET
      when E
        x += OFFSET
      when S
        y += OFFSET
      when W
        x -= OFFSET
      end
      if @prev == {x: x, y: y} # 逆戻りした場合の処理
        puts 'Cannot go back!'
      else
        return dir
      end
    end
  end

  # メイン。壁を置けるだけ置く
  def plotmaze
    loop do
      #最初の点を偶数点にランダムに置く
      x, y = plotrandom
      plot(x, y)
      @prev = {x: x, y: y}
      print "initial x: #{x}, y: #{y}\n"

      @len.times do
        dir = fortune(x, y)

        case dir
        when N
          if judge(x, y - OFFSET)
            y -= STEP; plot(x, y)
            y -= STEP; plot(x, y)
            puts 'go north'
          else                     # 壁に当たった場合の処理
            y -= STEP; plot(x, y)
            next
          end
        when E
          if judge(x + OFFSET, y)
            x += STEP; plot(x, y)
            x += STEP; plot(x, y)
            puts 'go east'
          else
            x += STEP; plot(x, y)
            next
          end
        when S
          if judge(x, y + OFFSET)
            y += STEP; plot(x, y)
            y += STEP; plot(x, y)
            puts 'go south'
          else
            y += STEP; plot(x, y)
            next
          end
        when W
          if judge(x - OFFSET, y)
            x -= STEP; plot(x, y)
            x -= STEP; plot(x, y)
            puts 'go west'
          else
            x -= STEP; plot(x, y)
            next
          end
        end
        @prev = {x: x, y: y}
        @limit -= 2
        puts "@limit: #{@limit}"
        if @limit <= 0
          return
        end
      end 

    end
  end

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
maze = Maze.new(5,5)
maze.plotmaze
maze.output
