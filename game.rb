require 'gosu'
require './ship.rb'
require './bullet.rb'
require './enemy.rb'

class GameWindow < Gosu::Window
  def initialize(*args)
    super
    @background = Gosu::Image.new('images/background.png', {tileable: true})
    @game_objects = {
      ships: Array.new,
      bullets: Array.new,
      enemies: Array.new
    }
    @game_objects[:ships] << @ship = Ship.new
    @bullets = Array.new
    @game_over_message = Gosu::Font.new(100)
    @game_over = false
    @timer = 0
  end

  def button_down(button)
    close if button == Gosu::KB_ESCAPE
  end

  def draw
    @background.draw(0, 0, 0)
    @game_objects.each do |k, game_object_array|
      game_object_array.each { |go|  go.draw }
    end
    @bullets.each {|bullet| bullet.draw}

    Gosu.draw_rect(50, 1250, (@ship.health * 3), 50, Gosu::Color::GREEN, 3)
    Gosu.draw_rect(50, 1250, 300, 50, Gosu::Color::BLACK, 2)

    Gosu.draw_rect(425, 1250, (@ship.ammo * 3), 50, Gosu::Color::RED, 3)
    Gosu.draw_rect(425, 1250, 300, 50, Gosu::Color::BLACK, 2)

    if @game_over
      @game_objects.each { |k, v| @game_objects.delete(k) }
      @game_over_message.draw("Game Over", 150, 500, 1)
    end
  end

  def update
    unless @game_over
      @ship.turn_left if Gosu.button_down? Gosu::KB_LEFT

      @ship.turn_right if Gosu.button_down? Gosu::KB_RIGHT

      @ship.accelerate if Gosu.button_down? Gosu::KB_UP

      bullet = @ship.fire if Gosu.button_down? Gosu::KB_SPACE
      @game_objects[:bullets] << bullet if bullet
      @timer += (0.1)
      @game_objects[:enemies] << Enemy.new if Enemy.spawn_new?(@timer.round(2))

      if @game_objects[:enemies].any?
        @game_objects[:enemies].each do |enemy|
          @game_objects[:enemies].delete_if {|enemy| enemy.dead }
          enemy.collide_with_game_object?(@game_objects[:bullets])
          enemy.collide_with_game_object?(@game_objects[:ships])
          enemy.aim(@ship)
          enemy.move
          enemy.die
        end
      end

      if @game_objects[:bullets].any?
        @game_objects[:bullets].each do |bullet|
          @game_objects[:bullets].delete_if {|bullet| bullet.out_of_frame? ||
                                                      bullet.collide_with_game_object?(@game_objects[:ships]) ||
                                                      bullet.collide_with_game_object?(@game_objects[:enemies])
          }
          bullet.move
        end
      end

      @ship.move
      @ship.recover_ammo
      @ship.collide_with_game_object?(@game_objects[:bullets])
      @ship.collide_with_game_object?(@game_objects[:enemies])
      @game_over = true if @ship.health.zero?
    end
  end
end

window = GameWindow.new(750, 1334, false)
window.show