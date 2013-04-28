# sends clicks to seeds / weeds
define_actor :harvester do
  behavior do
    requires :input_manager, :coordinates_translator, :world
    
    setup do
      input_manager.reg :mouse_down, MsRight do |event|
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        occupant = world.occupant_at(pos.x, pos.y)
        occupant.react_to :harvest if occupant
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
