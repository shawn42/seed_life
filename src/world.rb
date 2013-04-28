class World
  construct_with :config_manager, :director

  def initialize
    @old_things = []
    @grid = {}
    width, height = *config_manager[:screen_resolution]
    @width = width / CoordinatesTranslator::CELL_SIZE
    @height = height / CoordinatesTranslator::CELL_SIZE
    director.when(:post_update) do
      @old_things.each { |thing| thing.remove }
      @old_things.clear
    end
  end

  def occupant_at(x,y)
    @grid[x.to_i] ||= {}
    @grid[x.to_i][y.to_i]
  end
  alias occupant_at? occupant_at

  def in_bounds?(x,y)
    x >= 0 && x < @width && y >= 0 && y <= @height
  end

  def occupy(x,y,thing)
    @grid[x.to_i] ||= {}
    old_thing = @grid[x.to_i][y.to_i]
    @grid[x.to_i][y.to_i] = thing
    @old_things << old_thing if old_thing

    # seed_count = 0
    # @grid.each do |x, y_hash|
    #   y_hash.each do |y, thing|
    #     seed_count += 1 if thing
    #   end
    # end
    # log "SEED COUNT: #{seed_count}"
  end

  def occupants_for_box(x,y,w,h)
    occupants = []
    h.to_i.times do |i|
      w.to_i.times do |j|
        occ = occupant_at(x+i,y+j)
        occupants << occ if occ
      end
    end
    occupants
  end


end
