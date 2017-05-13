require 'gosu'
require 'HTTParty'
require './ship.rb'
require './bullet.rb'
require './enemy.rb'

class GameWindow < Gosu::Window
  def initialize(*args)
    super
    @background = Gosu::Image.new('images/background.png', {tileable: true})
    @timer = 0
    @score = 0
    @game_objects = {
      ships: Array.new,
      bullets: Array.new,
      enemies: Array.new
    }
    @game_objects[:ships] << @ship = Ship.new
    @game_over = false
    @score_posted = false
  end

  def button_down(button)
    close if button == Gosu::KB_ESCAPE
    reset if button == Gosu::KB_RETURN and @game_over
  end

  def draw
    @background.draw(0, -125, 0)
    @score_message = Gosu::Font.new(50, {name: 'OCR A Std'})
    @score_message.draw("#{@score}", 20, 20, 1) if !@game_over
    @game_objects.each do |k, game_object_array|
      game_object_array.each { |game_object|  game_object.draw if game_object }
    end

    Gosu.draw_rect(50, 1250, (@ship.health * 3), 50, Gosu::Color::GREEN, 3)
    Gosu.draw_rect(50, 1250, 300, 50, Gosu::Color::WHITE, 2)

    Gosu.draw_rect(425, 1250, (@ship.ammo * 3), 50, Gosu::Color::RED, 3)
    Gosu.draw_rect(425, 1250, 300, 50, Gosu::Color::WHITE, 2)

    if @game_over
      @game_objects.each { |k, v| @game_objects.delete(k) }
      @game_over_message = Gosu::Font.new(100, {name: 'OCR A Std'})
      @game_over_message.draw("Game Over", 50, 500, 1)
      @final_score_message = Gosu::Font.new(50, {name: 'OCR A Std'})
      @final_score_message.draw("Score: #{@score}", 185, 600, 1)
      @reset_message = Gosu::Font.new(25, {name: 'OCR A Std'})
      @reset_message.draw("Press [Return] to play again", 130, 700, 1)
      resp = HTTParty.post('http://salty-earth-58997.herokuapp.com/', { query: { name: "Player Name", score: @score, date: Date.today } }) if !@score_posted
      @score_posted = true if resp
    end
  end

  def update
    unless @game_over
      @timer += 0.1
      @score += 1

      @ship.turn_left if Gosu.button_down? Gosu::KB_LEFT
      @ship.turn_right if Gosu.button_down? Gosu::KB_RIGHT
      @ship.accelerate if Gosu.button_down? Gosu::KB_UP

      @game_objects[:bullets] << @ship.fire if Gosu.button_down? Gosu::KB_SPACE

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
          @game_objects[:bullets].delete_if {|bullet| (bullet.out_of_frame? ||
                                                      bullet.collide_with_game_object?(@game_objects[:ships]) ||
                                                      bullet.collide_with_game_object?(@game_objects[:enemies])) if bullet
          }
          bullet.move if bullet
        end
      end

      @ship.move
      @ship.recover_ammo
      @ship.collide_with_game_object?(@game_objects[:bullets])
      @ship.collide_with_game_object?(@game_objects[:enemies])
      @game_over = true if @ship.health.zero?
    end
  end

  private

  def reset
    @timer = 0
    @score = 0
    @game_objects = {
      ships: Array.new,
      bullets: Array.new,
      enemies: Array.new
    }
    @game_objects[:ships] << @ship = Ship.new
    @game_over = false
    @score_posted = false
  end
end

window = GameWindow.new(750, 1334, false)
window.show