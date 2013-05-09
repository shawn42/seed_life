CRITTER_COLORS = {
  fish: Color.argb(0xFFFF9C42),
} unless defined?(CRITTER_COLORS)

define_actor :critter_creator do
  has_behaviors do
  end

  behavior do
    requires :timer_manager, :world, :stage, :coordinates_translator
    
    setup do
      actor.has_attributes add_critter_every: 30_000

      timer_manager.add_timer critter_create_timer_name, actor.add_critter_every do
        add_critter
      end

      reacts_with :remove
    end

    helpers do
      def critter_create_timer_name; "critter_create_#{object_id}"; end

      def add_critter
        CRITTER_COLORS.each do |actor_type, color|
          self.send("create_#{actor_type}_if_needed")
        end
      end

      WATER_PER_FISH = 50
      def create_fish_if_needed
        fish = world.critters_of_type(:fish) || []
        seeds = world.all(World::GROUND)
        water_seeds = seeds.select{|seed| seed.actor_type == :water_seed}

        if fish.size * WATER_PER_FISH < water_seeds.size
          seed = water_seeds.sample
          pos = coordinates_translator.translate_world_to_screen(seed.position)
          stage.create_actor :fish, x: pos.x, y: pos.y
        end
      end
        
      def remove
        director.unsubscribe_all self
      end
    end
  end
end
