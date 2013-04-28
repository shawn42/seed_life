# checks whether or not the seed
# can be planted at the location and plant
# if it can
class Planter
  construct_with :stage, :world

  def plant(actor_type, opts={})
    x = opts[:x]
    y = opts[:y]
    if world.in_bounds?(x, y)
      # log "creating #{actor_type} at #{x},#{y}"
      stage.create_actor(actor_type, x: x , y: y) 
    end
  end

end
