# frozen_string_literal: true

require 'forwardable'

module Game
  class Player
    extend Forwardable

    attr_accessor :size, :color
    attr_reader :shape, :x, :y

    def initialize(x: , y:, size:, color: )
      @size = size
      @color = color
      @shape = Square.new(x: x, y: y, size: size, color: 'blue')
    end

    def x=(value)
      shape.x = value
    end

    def y=(value)
      shape.y = value
    end

    def_delegators :@shape, :width, :height, :x, :y
  end
end
