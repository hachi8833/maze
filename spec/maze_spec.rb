#!/usr/bin/env ruby
# coding: utf-8

require 'spec_helper'
# require 'rspec'
require 'maze'

describe :Point do
  it "インスタンスごとに異なる文字を出力" do
    maze = Maze.new(7, 3)
    expect(maze.road.output).to eq '　'
    expect(maze.wall.output).to eq '〓'
    expect(maze.prewall.output).to eq '$$'
  end
end

describe :Maze do

  it "引数なしのインスタンス作成は失敗する" do
    expect{Maze.new}.to raise_error(ArgumentError)
  end

  context "インスタンス作成" do
    before :each do
      @maze = Maze.new(7,3)
      @w = @maze.wall
      @p = @maze.prewall
      @r = @maze.road
    end

    it "インスタンスを作成できる" do
      expect(@maze.x).to eq 7
      expect(@maze.y).to eq 3
    end

    it "配列が正常に作成できる" do
     expect(@maze.array_2d).to eq [[@w, @w, @w], [@w, @r, @w], [@w, @r, @w], [@w, @r, @w], [@w, @r, @w], [@w, @r, @w],[@w, @w, @w]]
    end

    context "デフォルト迷路を正常に出力できる" do
      before { `echo "#!/usr/bin/env ruby\n# coding: utf-8\nrequire './lib/maze'\nmaze = Maze.new(7, 5)\nmaze.output" >> test.rb` }
      after { `rm -rf test.rb`}

      it :output do
        result = "〓〓〓〓〓\n〓　　　〓\n〓　　　〓\n〓　　　〓\n〓　　　〓\n〓　　　〓\n〓〓〓〓〓\n"

        expect(`ruby test.rb`).to eq result
      end
    end 
  end

  context "メソッドの単体テスト" do
    before :each do
      @maze = Maze.new(7,3)
      @w = @maze.wall
      @p = @maze.prewall
      @r = @maze.road
    end

    it :get_point do
      expect(@maze.get_point(0, 0)).to eq @w
      expect(@maze.get_point(1, 1)).to eq @r
      expect(@maze.get_point(5, 1)).to eq @r
      expect(@maze.get_point(6, 2)).to eq @w
      expect{@maze.get_point(7, 4)}.to raise_error(NoMethodError)
      expect{@maze.get_point(7, 7)}.to raise_error(NoMethodError)
    end

    it :set_point do
      @maze.set_point(0, 0, @maze.road)
      expect(@maze.get_point(0, 0)).to eq @r
      @maze.set_point(6, 2, @maze.road)
      expect(@maze.get_point(5, 1)).to eq @r
      expect{@maze.set_point(7, 7, @maze.road)}.to raise_error(NoMethodError)
    end
  end

  context :plot_maze do
  end
end
