#!/usr/bin/env ruby
# coding: utf-8

require 'pry'

#= 迷路自動作成ライブラリ
# 「壁伸ばし法」に基づく
# 参考: http://aanda.system.to/maze/wmaze.txt
class Maze

  # 初期値x, y。正の奇数かつ7以上にすること
  attr_accessor :x, :y
  # 作成された迷路が保存されている2次元配列
  attr_accessor :ary
  # 迷路の外側の壁の厚さ
  MARGIN = 1
  # 迷路作成上のオフセット値 
  OFFSET = 3
  # 迷路作成上の増分値
  INCR   = 2
  ROAD, WALL, PREWALL = nil, 1, 2
  R, W, P, LF = "　","〓","〓","\n"

  # 初期化 (prepare_aryとinit_aryもこの中から呼ばれている)
  def initialize(x, y)
    @x, @y = x, y
    @ary = prepare_ary(x, y)
    init_ary(x, y)
  end

  # 配列確保
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

  # 配列内容を初期化
  # 最外周は道になるので、外側の壁は1つ内側になる
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

  # 座標にあるものを調べる
  def getpoint(x, y)
    @ary[x][y]
  end

  # 座標に壁などを設置
  def setpoint(x, y, piece)
    @ary[x][y] = piece
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
    OFFSET.step(@y - 3, INCR) do |j|
      OFFSET.step(@x - 3, INCR) do |i|
        if getpoint(i, j) == ROAD
          result = maze_sub(i, j)
          next if result
        end
      end 
    end
  end

  # aryを整形して出力
  def output
    @ary.each do |i|
      i.each do |j|
        case j
        when WALL
          print W
        when PREWALL
          print P
        else
          print R 
        end
      end
      print LF
    end
  end
end
