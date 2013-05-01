define_actor :cloud_seed do
  has_attributes view: :seed_view,
    layered: ZOrder::Clouds
  
  has_behaviors do
    positioned
    seed grow_interval: 1_000
    puff_on_death
  end

  behavior do
    requires :world, :planter

    setup do
      actor.has_attributes color: Color.argb(rand(120..240), 0xDD, 0xDD, 0xDD)

      reacts_with :grow
    end

    helpers do
      def grow
        move_over 1, 0
        if false
        unless actor.x > 0
          up_modifier = relative_occupant(0, -1) ? 30 : 0
          down_modifier = relative_occupant(0, 1) ? 30 : 0

          up = (rand(100) - up_modifier) < 45
          down = (rand(100) - down_modifier) < 45

          grow_relative -1, -1 if up
          grow_relative -1, 0 if (up && down) || (rand(100) < 50)
          grow_relative -1, 1 if down
        end
        end
      end

      def move_over(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::SKY)
        planter.plant(:cloud_seed, x: x , y: y, color: actor.color, slice: World::SKY) unless occupant
        actor.remove
      end

      def relative_occupant(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        world.occupant_at(x, y, World::SKY)
      end

      def grow_relative(dx, dy)
        x = actor.x + dx + 1
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::SKY)
        planter.plant(:cloud_seed, x: x , y: y, slice: World::SKY) unless occupant
      end

    end
  end
end
