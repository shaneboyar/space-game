require 'gosu'
require './ship.rb'

class GameWindow < Gosu::Window
  def initialize(*args)
    super
    @ship = Ship.new
    @background = Gosu::Image.new('images/background.png', {tileable: true})
  end

  def button_down(button)
    close if button == Gosu::KB_ESCAPE
  end

  def draw
    @background.draw(0, 0, 0)
    @ship.draw
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @ship.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @ship.turn_right
    end
    if Gosu.button_down? Gosu::KB_UP
      @ship.accelerate
    end
    @ship.move
  end
end

window = GameWindow.new(750, 1334, false)
window.show