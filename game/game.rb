# frozen_string_literal: true

require 'byebug'
require 'ruby2d/ruby2d'
require 'ruby2d/colorize'
require 'ruby2d/exceptions'
require 'ruby2d/renderable'
require 'ruby2d/color'
require 'ruby2d/window'
require 'ruby2d/dsl'
require 'ruby2d/quad'
require 'ruby2d/line'
require 'ruby2d/circle'
require 'ruby2d/rectangle'
require 'ruby2d/square'
require 'ruby2d/triangle'
require 'ruby2d/image'
require 'ruby2d/sprite'
require 'ruby2d/font'
require 'ruby2d/text'
require 'ruby2d/sound'
require 'ruby2d/music'

require_relative 'player'

include Ruby2D

module Game
  class Window

    def player
      @player ||= Player.new(x: 10, y: 20, size: 20, color: 'blue')
    end

    def title(text = 'hello', rotate = 0)
      @title ||= Text.new(
        text,
        font: 'Verdana.ttf',
        x: get(:width) / 2, y: get(:height) / 2,
        size: 20,
        color: 'blue',
        rotate: rotate,
        z: 10
      )
    end

    def tick_actions
      @tick_actions ||= {}
    end

    def perform_tick_actions
      move_actions = tick_actions[:move]&.dup
      send(:move, move_actions.first, move_actions.last) if move_actions
    end

    def reset_tick_actions
      @tick_actions = {}
    end

    DIRECTIONS = %i[up down left right].freeze
    AXIS_AND_MODIFIERS = {
      up: [:y, :height, -1],
      down: [:y, :height, 1],
      left: [:x, :width, -1],
      right: [:x, :width, 1]
    }.freeze

    def move(object, direction)
      value = object.send(AXIS_AND_MODIFIERS[direction][0]) +
              object.send(AXIS_AND_MODIFIERS[direction][1]) * AXIS_AND_MODIFIERS[direction][2]
      value = 0 if value.negative?

      window_border_value = send(:get, AXIS_AND_MODIFIERS[direction][1])
      value = window_border_value - object.send(AXIS_AND_MODIFIERS[direction][1]) if (window_border_value - value) <= 0
      object.send("#{AXIS_AND_MODIFIERS[direction][0]}=", value)
    end

    def initialize
      extend Ruby2D::DSL

      set title: 'The Game'
      set background: :white

      tick = 0
      player
      title
      t = Time.now

      on :key do |e|
        if e.type == :down || e.type == :held
          case e.key
          when 's', 'down'
            tick_actions[:move] = [player, :down]
          when 'w', 'up'
            tick_actions[:move] = [player, :up]
          when 'a', 'left'
            tick_actions[:move] = [player, :left]
          when 'd', 'right'
            tick_actions[:move] = [player, :right]
          when 'q'
            close
          when 'r'
            player.x = 10
            player.y = 10
          end
        else
          case e.key
          when 's', 'down'
            tick_actions[:move] = nil
          when 'w', 'up'
            tick_actions[:move] = nil
          when 'a', 'left'
            tick_actions[:move] = nil
          when 'd', 'right'
            tick_actions[:move] = nil
          end
        end
      end

      update do
        if tick % 60 == 0
        end
        if tick.even?
          perform_tick_actions
          reset_tick_actions
        end

        @title.remove
        @title.text = tick
        @title.add

        tick += 1
      end

      show
    end
  end
end
