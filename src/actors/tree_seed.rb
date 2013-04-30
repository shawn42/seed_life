define_actor :tree_seed do
  has_attributes color: Color.argb(0xFF59955C),
    view: :seed_view
  
  has_behaviors do
    positioned
    seed grow_interval: 10_000
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
            grow_relative -1, 0 if tree_relative?(1,0)
            grow_relative 1, 0 if tree_relative?(-1,0)
            grow_relative 0, 1 if tree_relative?(0,-1)
            grow_relative 0, -1 if tree_relative?(0,1)
          end
        end
      end

      def tree_relative?(dx, dy)
        occ = world.occupant_at(actor.x+dx, actor.y+dy, World::GROUND)
        occ && occ.actor_type == :tree_seed
      end

      def can_grow?
        if actor.pattern_number < 3
          # TODO change to take a Rect
          others = world.occupants_for_box(actor.x - 4, actor.y - 4, World::GROUND, 8, 8)
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
