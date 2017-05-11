require 'gosu'

class Ship
  def initialize
    @sprite = Gosu::Image.new('images/ship.png').subimage(0,0,32,32)
    @position = { x: 375, y: 667, angle: 0.0 }
    @velocity = { x: 0, y: 0 }
    @score = 0
  end

  def turn_left
    @position[:angle] -= 4.5
  end

  def turn_right
    @position[:angle] += 4.5
  end

  def accelerate
    @velocity[:x] += Gosu.offset_x(@position[:angle], 0.5)
    @velocity[:y] += Gosu.offset_y(@position[:angle], 0.5)
  end

  def move
    @position[:x] += @velocity[:x]
    @position[:y] += @velocity[:y]

    @position[:x] %= 750
    @position[:y] %= 1334

    @velocity[:x] *= 0.95
    @velocity[:y] *= 0.95
  end

  def draw
    @sprite.draw_rot(@position[:x], @position[:y], 1, @position[:angle])
  end
end