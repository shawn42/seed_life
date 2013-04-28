define_actor :water_seed do
  has_attributes color: Color.argb(0xFF00BFFF),
    view: :seed_view
  
  has_behaviors do
    positioned
    seed grow_interval: 2_000
  end

  behavior do
    requires :world, :stage

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
        occupant = world.occupant_at(x, y)
        seed = stage.create_actor(:water_seed, x: x , y: y, pattern_number: actor.pattern_number+1) unless occupant && [:water_seed, :rock_seed].include?(occupant.actor_type)
      end

    end
  end
end
