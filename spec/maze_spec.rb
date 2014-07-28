#!/usr/bin/env ruby
# coding: utf-8

require 'spec_helper'
# require 'rspec'
require 'maze'
require 'pry'

describe :Point do
  it "インスタンスごとに異なる文字を出力" do
    maze = Maze.new(7, 3)
    binding.pry
    expect(maze.road.output).to eq '　'
    expect(maze.wall.output).to eq '〓'
    expect(maze.prewall.output).to eq '〓'
  end
end

describe :Maze do

  it "引数なしのインスタンス作成は失敗する" do
  end

  context "インスタンス作成" do
    before :each do
    end

    it "インスタンスを作成できる" do
    end

    it "配列が正常に作成できる" do
    end
  end

  context "メソッドの単体テスト" do
    before :each do end

    it :init_ary do
    end

    it :getpoint do
    end

    it :setpoint do
    end
  end

  context :plotmaze do
  end
end
