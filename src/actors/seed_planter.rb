 # TODO this guy will have a view that draws the dragging line
define_actor :seed_planter do
  behavior do
    requires :world, :input_manager, :planter, :coordinates_translator
    
    setup do
      actor.has_attributes current_seed: :rock_seed, producing: false
      # TODO loop over seed types?
      input_manager.reg(:down, Kb1) { change_seed_to :rock_seed }
      input_manager.reg(:down, Kb2) { change_seed_to :water_seed }
      input_manager.reg(:down, Kb3) { change_seed_to :bush_seed }
      input_manager.reg(:down, Kb4) { change_seed_to :vine_seed }
      input_manager.reg(:down, Kb5) { change_seed_to :tree_seed }
      input_manager.reg(:down, Kb6) { change_seed_to :flower_seed }
      input_manager.reg(:down, Kb0) { change_seed_to :weed_seed }

      input_manager.reg :mouse_down, MsLeft do |event|
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        planter.plant(actor.current_seed, x: pos.x, y: pos.y) unless world.occupant_at?(pos.x,pos.y, World::GROUND)
        actor.producing = true
      end

      input_manager.reg :mouse_motion do |event|
        if actor.producing
          pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
          planter.plant(actor.current_seed, x: pos.x, y: pos.y) unless world.occupant_at?(pos.x,pos.y, World::GROUND)
          actor.producing = true
        end
      end

      input_manager.reg(:mouse_up, MsLeft) { actor.producing = false }

      reacts_with :remove
    end

    helpers do
      def change_seed_to(seed_type)
        actor.current_seed = seed_type
      end

      def remove
        input_manager.unsubscribe_all self
      end
    end
  end
end
