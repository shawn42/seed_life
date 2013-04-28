 # TODO this guy will have a view that draws the dragging line
define_actor :seed_planter do
  behavior do
    requires :world, :input_manager, :stage, :coordinates_translator
    
    setup do
      actor.has_attributes current_seed: :rock_seed
      # TODO loop over seed types?
      input_manager.reg(:down, Kb1) { change_seed_to :rock_seed }
      input_manager.reg(:down, Kb2) { change_seed_to :water_seed }
      input_manager.reg(:down, Kb3) { change_seed_to :bush_seed }
      input_manager.reg(:down, Kb4) { change_seed_to :vine_seed }
      input_manager.reg(:down, Kb5) { change_seed_to :tree_seed }
      input_manager.reg(:down, Kb0) { change_seed_to :weed_seed }

      input_manager.reg :mouse_up, MsLeft do |event|
        # XXX known bug, will try to create seed from this event AND the drag event
        # the world wont allow it for now
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        stage.create_actor actor.current_seed, x: pos.x, y: pos.y unless world.occupant_at?(pos.x,pos.y)
      end

      input_manager.reg :mouse_drag, MsLeft do |event|
        to = vec2(*event[:data][:to])
        from = vec2(*event[:data][:from])
        to = coordinates_translator.translate_screen_to_world(to)
        from = coordinates_translator.translate_screen_to_world(from)

        # ug.. polaris is not doing me any favors here
        coords = LineOfSite.new(nil).brensenham_line(from.x.to_i, from.y.to_i, to.x.to_i, to.y.to_i)

        coords.each do |(x,y)|
          # TODO change this to use seed_inspector#can_plant?(type, x, y)
          stage.create_actor actor.current_seed, x: x, y: y unless world.occupant_at?(x,y)
        end
      end

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
