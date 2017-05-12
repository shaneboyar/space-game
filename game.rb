require 'gosu'
require './ship.rb'
require './bullet.rb'

class GameWindow < Gosu::Window
  def initialize(*args)
    super
    @ship = Ship.new
    @background = Gosu::Image.new('images/background.png', {tileable: true})
    @bullets =[]
  end

  def button_down(button)
    close if button == Gosu::KB_ESCAPE
  end

  def draw
    @background.draw(0, 0, 0)
    @ship.draw
    @bullets.each {|bullet| bullet.draw}
  end

  def update
    @ship.turn_left if Gosu.button_down? Gosu::KB_LEFT

    @ship.turn_right if Gosu.button_down? Gosu::KB_RIGHT

    @ship.accelerate if Gosu.button_down? Gosu::KB_UP

    @bullets << @ship.fire if Gosu.button_down? Gosu::KB_SPACE

    if @bullets.any?
      @bullets.each do |bullet|
        @bullets.delete_if {|bullet| bullet.out_of_frame?}
        bullet.move
      end
    end
    @ship.move
  end
end

window = GameWindow.new(750, 1334, false)
window.show