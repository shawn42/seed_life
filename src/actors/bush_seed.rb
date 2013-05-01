define_actor :bush_seed do
  has_attributes view: :seed_view
  
  has_behaviors do
    positioned
    layered ZOrder::Seeds
    seed grow_interval: 5_000
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
        if can_grow?
          # TODO only do this once per water seed?
          grow_relative 0, 1
          grow_relative 1, 0
          grow_relative 0, -1
          grow_relative -1, 0
          grow_relative 1, 1
          grow_relative 1, -1
          grow_relative -1, 1
          grow_relative -1, -1
        end
      end
      def can_grow?
        if actor.pattern_number < 2
          others = world.occupants_for_box(actor.x - 3, actor.y - 3, World::GROUND, actor.x + 3, actor.y + 3)
          others.any?{|actor| actor.actor_type == :water_seed}
        end
      end

      def grow_relative(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::GROUND)
        planter.plant(actor.actor_type, x: x , y: y, pattern_number: actor.pattern_number+1) unless occupant
      end

    end
  end
end
