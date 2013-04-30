define_actor :weed_planter do
  behavior do
    requires :planter, :timer_manager, :world
    
    setup do
      actor.has_attributes force_weed_every: 30_000

      timer_manager.add_timer weed_timer_name, actor.force_weed_every do
        add_weed
      end

      reacts_with :remove
    end

    helpers do
      def add_weed
        x = rand(50)
        y = rand(40)
        planter.plant(:weed_seed, x: x , y: y) unless world.occupant_at?(x, y, World::GROUND)
      end
        

      def weed_timer_name; "grow_weeds_#{object_id}" end
      def remove
        timer_manager.remove_timer weed_timer_name
      end
    end
  end
end
