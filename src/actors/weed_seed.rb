define_actor :weed_seed do
  has_attributes color: Color.argb(0xFFFF5353),
    view: :seed_view

  has_behaviors do
    positioned
    seed grow_interval: 10_000
  end

  behavior do
    requires :world, :stage, :planter

    setup do
      reacts_with :harvest, :grow
    end

    helpers do
      def harvest
        actor.remove
      end

      def grow
        if room_to_grow?
          dx = rand(8) - 4
          dy = rand(8) - 4
          x = actor.x + dx
          y = actor.y + dy
          planter.plant(actor.actor_type, x: x , y: y) unless world.occupant_at?(x, y)
        end
      end

      def room_to_grow?
        others = world.occupants_for_box(actor.x - 3, actor.y - 3, actor.x + 3, actor.y + 3)
        others.select{|other|other.actor_type == actor.actor_type}.size < 3
      end
    end
  end
end
