#!/usr/bin/env ruby
# coding: utf-8

require './lib/maze.rb'

x, y = 31, 41

x += 1 if x.even?
y += 1 if y.even?
maze = Maze.new(x, y)
maze.plotmaze
maze.output
