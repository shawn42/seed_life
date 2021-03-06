define_actor :flower_seed do
  has_attributes view: :seed_view
  
  has_behaviors do
    positioned
    layered ZOrder::Seeds
    seed grow_interval: 5_500
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
          case actor.pattern_number
          when 1
            grow_relative 0, 1
            grow_relative 1, 0
            grow_relative 0, -1
            grow_relative -1, 0
          when 2, 3
            grow_relative -2, 0
            grow_relative 2, 0
            grow_relative 0, 2
            grow_relative 0, -2
          end
        end
      end

      def can_grow?
        actor.pattern_number < 4
      end

      def colors
        @colors ||= [0xFF7979FF, 0xFFFF86FF, 0xFFCD85FE, 0xFFB0A7F1, 0xFFFFFF84].map{|c|Color.argb(c)}
      end

      def grow_relative(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::GROUND)
        planter.plant(actor.actor_type, x: x , y: y, color: colors.sample, pattern_number: actor.pattern_number+1) unless occupant
      end
    end
  end
end
