# sends clicks to seeds / weeds
define_actor :harvester do
  behavior do
    requires :input_manager, :coordinates_translator, :world
    
    setup do
      actor.has_attributes harvesting: false

      input_manager.reg :mouse_down, MsRight do |event|
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        occupant = world.occupant_at(pos.x, pos.y, World::GROUND)
        occupant.react_to :harvest if occupant
        actor.harvesting = true
      end

      input_manager.reg :mouse_motion do |event|
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        occupant = world.occupant_at(pos.x, pos.y, World::SKY)
        occupant.react_to :disperse if occupant

        if actor.harvesting?
          occupant = world.occupant_at(pos.x, pos.y, World::GROUND)
          occupant.react_to :harvest if occupant
        end
      end

      input_manager.reg :mouse_up, MsRight do |event|
        actor.harvesting = false
      end


      reacts_with :remove
    end

    helpers do
      def remove
        input_manager.unsubscribe_all self
      end
    end
  end
end
