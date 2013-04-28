define_actor :bush_seed do
  has_attributes color: Color.argb(0xFF74BAAC),
    view: :seed_view
  
  has_behaviors do
    positioned
    seed grow_interval: 4_000
  end

  behavior do
    requires :world, :stage

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
          others = world.occupants_for_box(actor.x - 3, actor.y - 3, actor.x + 3, actor.y + 3)
          others.any?{|actor| actor.actor_type == :water_seed}
        end
      end

      def grow_relative(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y)
        stage.create_actor(actor.actor_type, x: x , y: y, pattern_number: actor.pattern_number+1) unless occupant
      end

    end
  end
end
