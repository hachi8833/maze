#!/usr/bin/env ruby
# coding: utf-8

require 'spec_helper'
# require 'rspec'
require 'maze'

describe :Maze do

  it "引数なしのインスタンス作成は失敗する" do
    expect{Maze.new}.to raise_error(ArgumentError)
  end

  context "インスタンス作成" do
    before :each do
      @maze = Maze.new(7, 7)
    end

    it "インスタンスを作成できる" do
      expect(@maze.x).to eq 7
      expect(@maze.y).to eq 7
    end

    it "配列が正常に作成できる" do
      expect(@maze.ary_2d).to eq [[nil, nil, nil, nil, nil, nil, nil], [nil, 1, 1, 1, 1, 1, nil], [nil, 1, nil, nil, nil, 1, nil], [nil, 1, nil, nil, nil, 1, nil], [nil, 1, nil, nil, nil, 1, nil], [nil, 1, 1, 1, 1, 1, nil], [nil, nil, nil, nil, nil, nil, nil]] 
    end
  end

  context "メソッドの単体テスト" do
    before :each do @maze = Maze.new(5, 5) end

    # it :prepare_ary do
    #   @maze.prepare_ary(5, 5)
    #   expect(@maze.ary_2d).to eq [[nil, nil, nil, nil, nil], [nil, 1, 1, 1, nil], [nil, 1, nil, 1, nil], [nil, 1, 1, 1, nil], [nil, nil, nil, nil, nil]] 

    #   @maze = Maze.new(3, 3)
    #   @maze.prepare_ary(3, 3)
    #   expect(@maze.ary_2d).to eq [[nil, nil, nil], [nil, 1, nil], [nil, nil, nil]]
    # end

    it :init_ary do
      expect(@maze.ary_2d).to eq [[nil, nil, nil, nil, nil], [nil, 1, 1, 1, nil], [nil, 1, nil, 1, nil], [nil, 1, 1, 1, nil], [nil, nil, nil, nil, nil]]
    end

    it :getpoint do
      expect(@maze.getpoint(2, 3)).to eq 1
      expect(@maze.getpoint(2, 2)).to eq nil
      expect{@maze.getpoint(6, 6)}.to raise_error(NoMethodError)
    end

    it :setpoint do
      @maze.setpoint(2, 3, nil)
      expect(@maze.getpoint(2, 3)).to eq nil
      @maze.setpoint(2, 3, 1)
      expect(@maze.getpoint(2, 3)).to eq 1

      @maze.setpoint(3, 2, nil)
      expect(@maze.getpoint(3, 2)).to eq nil
      @maze.setpoint(3, 2, 1)
      expect(@maze.getpoint(3, 2)).to eq 1

      expect{@maze.setpoint(6, 6, 1)}.to raise_error(NoMethodError)
    end
  end

  context :plotmaze do
    @maze = Maze.new(9, 9)
    # ペンディング: RSpec 3.0でmaze_subをどうやってスタブ化する?
    # allow(@maze).to receive(:maze_sub) { true }
    # @maze.plotmaze.stub(maze_sub: true)
    #allow(@maze.plotmaze).receive(:maze_sub) { true }
  end
end
