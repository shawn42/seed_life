define_actor :cloud_seed do
  has_attributes view: :seed_view,
    layered: ZOrder::Clouds
  
  has_behaviors do
    positioned
    seed grow_interval: 1_000
  end

  behavior do
    requires :world, :planter

    setup do
      actor.has_attributes color: Color.argb(rand(120..240), 0xDD, 0xDD, 0xDD)

      reacts_with :grow, :disperse
    end

    helpers do
      def disperse
        # tween the size up and the alpha down til removal
        actor.remove
      end

      def grow
        move_over 1, 0
        unless actor.x > 0
          up = rand(100) < 15
          down = rand(100) < 15

          grow_relative -1, -1 if up
          grow_relative -1, 0 if up && down || rand(100) < 50
          grow_relative -1, 1 if down
        end
      end

      def move_over(dx, dy)
        x = actor.x + dx
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::SKY)
        planter.plant(:cloud_seed, x: x , y: y, color: actor.color, slice: World::SKY) unless occupant
        actor.remove
      end

      def grow_relative(dx, dy)
        x = actor.x + dx + 1 # account for the "move"
        y = actor.y + dy
        occupant = world.occupant_at(x, y, World::SKY)
        planter.plant(:cloud_seed, x: x , y: y, slice: World::SKY) unless occupant
      end

    end
  end
end
