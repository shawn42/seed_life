class World
  def initialize
    @grid = {}
  end

  def occupant_at(x,y)
    @grid[x.to_i] ||= {}
    @grid[x.to_i][y.to_i]
  end
  alias occupant_at? occupant_at

  def occupy(x,y,thing)
    @grid[x.to_i] ||= {}
    old_thing = @grid[x.to_i][y.to_i]
    @grid[x.to_i][y.to_i] = thing

    old_thing.remove if old_thing && old_thing.respond_to?(:remove)

    # seed_count = 0
    # @grid.each do |x, y_hash|
    #   y_hash.each do |y, thing|
    #     seed_count += 1 if thing
    #   end
    # end
    # log "ADDED #{thing.actor_type}"
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
