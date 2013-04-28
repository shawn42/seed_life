# checks whether or not the seed
# can be planted at the location and plant
# if it can
class Planter
  construct_with :stage, :world

  def plant(actor_type, opts={})
    x = opts[:x]
    y = opts[:y]
    stage.create_actor(actor_type, opts) if world.in_bounds?(x, y)
  end

end
