require 'gosu'

class Bullet
  def initialize(position)
    @position = {
      x: position[:x] + Gosu::offset_x(position[:angle], 15),
      y: position[:y] + Gosu::offset_y(position[:angle], 15),
      angle: position[:angle],
    }
    @sprite = Gosu::Image.new('images/laser.png').subimage(0,0,12,32)
    @velocity = { x: 1, y: 1 }
  end

  def move
    @position[:x] += Gosu.offset_x(@position[:angle], @velocity[:x] *= 1.05)
    @position[:y] += Gosu.offset_y(@position[:angle], @velocity[:y] *= 1.05)
  end

  def draw
    @sprite.draw_rot(@position[:x], @position[:y], 1, @position[:angle])
  end

  def out_of_frame?
    !@position[:x].between?(0,750) or !@position[:y].between?(0,1334)
  end
end