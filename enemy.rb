class Enemy
  attr_reader :ammo
  attr_reader :health
  attr_reader :position
  attr_reader :dead

  def initialize
    @sprite = Gosu::Image.new('images/enemy.png').subimage(0,0,32,32)
    @position = { x: rand(0..750), y: rand(0..1200), angle: rand(0..360) }
    @velocity = { x: 1, y: 1 }
    @score = 0
    @health = 1
    @ammo = 100
    @dead = false
  end

  def self.spawn_new?(timer)
    (timer % 10).zero?
  end

  def turn_left
    @position[:angle] -= 4.5
  end

  def turn_right
    @position[:angle] += 4.5
  end

  # def accelerate
  #   @velocity[:x] += Gosu.offset_x(@position[:angle], 0.5)
  #   @velocity[:y] += Gosu.offset_y(@position[:angle], 0.5)
  # end

  def move
    @position[:x] += Gosu.offset_x(@position[:angle], @velocity[:x] *= 1)
    @position[:y] += Gosu.offset_y(@position[:angle], @velocity[:y] *= 1)

    @position[:x] %= 750
    @position[:y] %= 1200

    @velocity[:x] *= 1.0005
    @velocity[:y] *= 1.0005
  end

  def aim(target)
    @position[:angle] = Gosu.angle(@position[:x], @position[:y], target.position[:x], target.position[:y])
  end

  def fire
    @ammo = @ammo > 0 ? @ammo -= 2 : 0
    bullet = Bullet.new(@position) if (@ammo > 0)
  end

  def die
    @dead = true if @health.zero?
  end

  def collide_with_game_object?(game_object_array)
    @health -= 1 if game_object_array.any? { |game_object| Gosu.distance(@position[:x], @position[:y], game_object.position[:x], game_object.position[:y]) < 20 if game_object}
  end

  def draw
    @sprite.draw_rot(@position[:x], @position[:y], 1, @position[:angle])
  end
end