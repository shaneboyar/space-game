require 'gosu'

class Bullet < Ship
  def initialize
    super
    @sprite = Gosu::Image.new('images/laser.png').subimage(0,0,12,32)
    @velocity = { x: 1, y: 1 }
  end

  # def accelerate
  #   @velocity[:x] += Gosu.offset_x(@position[:angle], 0.5)
  #   @velocity[:y] += Gosu.offset_y(@position[:angle], 0.5)
  # end

  def move
    @position[:x] += Gosu.offset_x(@position[:angle], @velocity[:x] *= 1.05)
    @position[:y] += Gosu.offset_y(@position[:angle], @velocity[:y] *= 1.05)
  end

  def draw
    @sprite.draw_rot(@position[:x], @position[:y], 1, @position[:angle])
  end
end