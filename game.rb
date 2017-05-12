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
    if button == Gosu::KB_SPACE
      @bullets << @ship.fire
      puts "***#{@bullets}****"
    end
  end

  def draw
    @background.draw(0, 0, 0)
    @ship.draw
    @bullets.each {|bullet| bullet.draw}
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