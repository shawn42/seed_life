define_actor :weed_seed do
  has_attributes view: :seed_view

  has_behaviors do
    positioned
    layered ZOrder::Seeds
    seed grow_interval: 10_000
    oversize_on_create
    pop_on_create
  end

  behavior do
    requires :world, :planter

    setup do
      reacts_with :grow
    end

    helpers do
      def grow
        if room_to_grow?
          dx = rand(8) - 4
          dy = rand(8) - 4
          x = actor.x + dx
          y = actor.y + dy
          planter.plant(actor.actor_type, x: x , y: y) unless world.occupant_at?(x, y, World::GROUND)
        end
      end

      def room_to_grow?
        others = world.occupants_for_box(actor.x - 3, actor.y - 3, World::GROUND, 6, 6)
        others.select{|other|other.actor_type == actor.actor_type}.size < 3
      end
    end
  end
end
