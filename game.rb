require 'gosu'


class GameWindow < Gosu::Window
  def initialize(*args)
    super

    @background = Gosu::Image.new('images/background.png', {tileable: true})
  end

  def button_down(button)
    close if button == Gosu:: KbEscape
  end

  def draw
    @background.draw(0, 0, 0)
  end
end

window = GameWindow.new(750, 1334, false)
window.show