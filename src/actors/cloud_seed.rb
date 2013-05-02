define_actor :cloud_seed do
  has_attributes view: :seed_view
  
  has_behaviors do
    positioned
    layered ZOrder::Clouds
    seed grow_interval: 1_000
    puff_on_death
  end

  behavior do
    requires :world, :planter

    setup do
      actor.has_attributes :color
      actor.color = Color.argb(rand_from_range(120..240), 0xDD, 0xDD, 0xDD)

      reacts_with :grow
    end

    helpers do
      def grow
        move_over 1, 0
        unless actor.x > 1
          up_modifier = relative_occupant(0, -1) ? 30 : 0
          down_modifier = relative_occupant(0, 1) ? 30 : 0

          up = (rand(100) - up_modifier) < 35
          down = (rand(100) - down_modifier) < 35

          grow_relative -1, -1 if up
          grow_relative -1, 0 if (up && down) || (rand(100) < 40)
          grow_relative -1, 1 if down
        end
      end

      def move_over(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        world.move!(actor.x, actor.y, World::SKY, x, y, World::SKY)
        actor.update_attributes(x: x, y: y)
      end

      def relative_occupant(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        world.occupant_at(x, y, World::SKY)
      end

      def grow_relative(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::SKY)
        planter.plant(:cloud_seed, x: x , y: y, slice: World::SKY) unless occupant
      end

    end
  end
end
