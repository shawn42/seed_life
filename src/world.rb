class World
  construct_with :config_manager, :director

  attr_accessor :height, :width

  GROUND = 0
  SKY = 1

  def initialize
    # TODO possibly hash these by type?
    @critters = []
    @old_things = []
    @grid = Hash.new { |h, k| h[k] = {} }
    width, height = *config_manager[:screen_resolution]
    @width = width / CoordinatesTranslator::CELL_SIZE
    @height = height / CoordinatesTranslator::CELL_SIZE
    director.when(:post_update) do
      @old_things.each { |thing| thing.remove }
      @old_things.clear
    end
  end

  def add_critter(critter)
    @critters << critter
  end

  def remove_critter(critter)
    @critters.delete(critter)
  end

  def critters_of_type(type)
    @critters.select{|critter| critter.actor_type == type}
  end

  def all(z)
    @grid[z].values.map(&:values).flatten.compact
  end

  def occupant_at(x,y,z)
    @grid[z][x.to_i] ||= {}
    @grid[z][x.to_i][y.to_i]
  end
  alias occupant_at? occupant_at

  def in_bounds?(x,y)
    x >= 0 && x < @width && y >= 0 && y <= @height
  end

  def move!(x,y,z, xx,yy,zz)
    @grid[z][x.to_i] ||= {}
    thing = @grid[z][x.to_i][y.to_i]
    @grid[z][x.to_i][y.to_i] = nil

    if in_bounds?(xx, yy)
      occupy(xx,yy,zz, thing)
    else
      thing.remove
    end
  end

  def occupy(x,y,z,thing)
    @grid[z][x.to_i] ||= {}
    old_thing = @grid[z][x.to_i][y.to_i]
    @grid[z][x.to_i][y.to_i] = thing
    @old_things << old_thing if old_thing && thing
  end

  def occupants_for_box(x,y,z,w,h)
    occupants = []
    h.to_i.times do |i|
      w.to_i.times do |j|
        occ = occupant_at(x+i,y+j,z)
        occupants << occ if occ
      end
    end
    occupants
  end


end
