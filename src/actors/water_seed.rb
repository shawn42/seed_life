define_actor :water_seed do
  has_attributes view: :seed_view
  
  has_behaviors do
    positioned
    layered ZOrder::Seeds
    seed grow_interval: 2_000
    oversize_on_create
    pop_on_create
  end

  behavior do
    requires :world, :planter

    setup do
      actor.has_attributes pattern_number: 1

      reacts_with :grow #, :harvest 
    end

    helpers do
      def grow
        if actor.pattern_number <= 2
          grow_relative 0, 1
          grow_relative 1, 0
          grow_relative 0, -1
          grow_relative -1, 0
        end
      end

      def grow_relative(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::GROUND)
        planter.plant(:water_seed, x: x , y: y, pattern_number: actor.pattern_number+1) unless occupant && [:water_seed, :rock_seed].include?(occupant.actor_type)
      end

    end
  end
end
