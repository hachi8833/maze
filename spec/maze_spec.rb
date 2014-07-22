#!/usr/bin/env ruby
# coding: utf-8

require 'spec_helper'
require 'maze'

describe :Maze do
  
  it "引数なしのインスタンス作成は失敗する" do
    expect{Maze.new}.to raise_error(ArgumentError)
  end

  context "インスタンス作成" do

    maze = Maze.new(7, 7)

    it "インスタンスを作成できる" do
      expect(maze.x).to eq 7
      expect(maze.y).to eq 7
    end

    it "配列が正常に作成できる" do
      expect(maze.ary).to eq   [[1, 1, 1, 1, 1, 1, 1], [1, nil, nil, nil, nil, nil, 1],[1, nil, nil, nil, nil, nil, 1],[1, nil, nil, nil, nil, nil, 1],[1, nil, nil, nil, nil, nil, 1],[1, nil, nil, nil, nil, nil, 1],[1, 1, 1, 1, 1, 1, 1]]
    end

    context "メソッドの単体テスト" do
      it :prepare_ary do
        maze = Maze.new(3, 3)
        maze.prepare_ary(3, 3)
        expect(maze.ary).to eq [[1, 1, 1], [1, nil, 1],[1, 1, 1]]

        maze = Maze.new(5, 5)
        maze.prepare_ary(5, 5)
        expect(maze.ary).to eq [[1, 1, 1, 1, 1], [1, nil, nil, nil, 1], [1, nil, nil, nil, 1], [1, nil, nil, nil, 1], [1, 1, 1, 1, 1]]
      end
      
      it :init_ary do
        maze.init_ary(5, 5)
        expect(maze.ary).to eq [[nil, nil, nil, nil, nil], [nil, 1, 1, 1, nil], [nil, 1, nil, 1, nil], [nil, 1, 1, 1, nil], [nil, nil, nil, nil, nil]]
      end

      it :getpoint do
        expect(maze.getpoint(2, 3)).to eq 1
        expect(maze.getpoint(2, 2)).to eq nil
        expect{maze.getpoint(6, 6)}.to raise_error(NoMethodError)
      end

      it :setpoint do
        maze.setpoint(2, 3, nil)
        expect(maze.getpoint(2, 3)).to eq nil
        maze.setpoint(2, 3, 1)
        expect(maze.getpoint(2, 3)).to eq 1

        maze.setpoint(3, 2, nil)
        expect(maze.getpoint(3, 2)).to eq nil
        maze.setpoint(3, 2, 1)
        expect(maze.getpoint(3, 2)).to eq 1

        expect{maze.setpoint(6, 6, 1)}.to raise_error(NoMethodError)
      end
    end
  end
end
