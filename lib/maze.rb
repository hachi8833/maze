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
class Maze

  # 初期値x, y。正の奇数かつ7以上にすること
  attr_accessor :x, :y
  # 作成された迷路が保存されている2次元配列
  attr_accessor :array_2d
  ROAD, WALL, PREWALL = nil, 1, 2
  # 表示用文字

  CHARACTERS = { ROAD => '　', WALL => '〓', PREWALL => '〓' }.freeze
  # 初期化 (prepare_arrayとinit_arrayもこの中から呼ばれている)
  def initialize(x, y)
    # 迷路の外側の壁の厚さ
    @margin = 1.freeze
    # 迷路作成上のオフセット値 
    @offset = 3.freeze
    # 迷路作成上の増分値

    @increment   = 2.freeze
    @x, @y = x.freeze, y.freeze
    @array_2d = prepare_array(x, y)
    init_array(x, y)
  end

  # 座標にあるものを調べる
  def getpoint(x, y)
    @array_2d[x][y]
  end

  # 座標に壁などを設置
  def setpoint(x, y, piece)
    @array_2d[x][y] = piece
  end

  # 壁を1つ作成、伸ばせるところまで伸ばす
  def maze_sub(x, y)
    rnd = rand(0..3)
    pol = 1 # 回転の向き

    4.times do |cnt| # 方向転換の回数
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

      # 壁にぶつかったら壁までつないで戻る
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

  # 壁の開始地点をトラバースしてmaze_subを呼び続ける
  def plotmaze
    @offset.step(@y - 3, @increment) do |y|
      @offset.step(@x - 3, @increment) do |x|
        if getpoint(x, y) == ROAD
          result = maze_sub(x, y)
          next if result
        end
      end 
    end
  end

  # array_2dを整形して出力
  def output
    @array_2d.each do |line|
      puts line.map { |c| CHARACTERS[c] }.join
    end
  end

  private

  # 配列確保
  def prepare_array(x, y)
    array_2d, tmp = [], []

    #最初の行
    array_2d << [WALL] * y

    #途中の行
    tmp << WALL
    (y - 2).times { tmp << ROAD }
    tmp << WALL
    (x - 2).times {array_2d << tmp.dup }

    #最後の行
    array_2d << [WALL] * y
    return array_2d
  end

  # 配列内容を初期化
  # 最外周は道になるので、外側の壁は1つ内側になる
  def init_array(x, y)
    x.times do |xx|
      y.times do |yy|
        setpoint(xx, yy, ROAD)
      end
    end

    (@margin..(@x - 2)).each do |i|
      setpoint(i, 1, WALL)
      setpoint(i, @y - 2, WALL)
    end 

    (@margin..(@y - 2)).each do |j|
      setpoint(1, j, WALL)
      setpoint(@x - 2, j, WALL)
    end 
  end
end
