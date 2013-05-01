define_actor :cloud_planter do
  behavior do
    requires :planter, :timer_manager, :world
    
    setup do
      actor.has_attributes force_cloud_every: 6_000

      timer_manager.add_timer cloud_timer_name, actor.force_cloud_every do
        add_clouds
      end
      add_clouds

      reacts_with :remove
    end

    helpers do
      def add_clouds
        rand(0..2).times do
          if rand(100) < 30
            y = rand(40)
            planter.plant(:cloud_seed, x: 0 , y: y, slice: World::SKY) unless world.occupant_at?(0, y, World::SKY)
          end
        end
      end

      def cloud_timer_name; "grow_clouds_#{object_id}" end
      def remove
        timer_manager.remove_timer cloud_timer_name
      end
    end
  end
end
