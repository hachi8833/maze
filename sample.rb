#!/usr/bin/env ruby
# coding: utf-8

require './lib/maze.rb'

x, y = 31, 41

maze = Maze.new(x, y)
maze.build_maze
maze.output
