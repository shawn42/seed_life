define_actor :fish do
  has_attributes view: :critter_view
  
  has_behaviors do
    positioned
    layered ZOrder::Critters
    oversize_on_create
    critter act_interval: 3_000
  end

  behavior do
    requires :world, :coordinates_translator
    setup do
      reacts_with :act
    end

    helpers do
      FISH_ACTIONS = [
        :stay,
        :swim_up,
        :swim_down,
        :swim_left,
        :swim_right,
      ] unless defined?(FISH_ACTIONS)
      SWIM_VECTORS = {
        swim_up: vec2(0,-1),
        swim_down: vec2(0,1),
        swim_left: vec2(-1,0),
        swim_right: vec2(1,0),
      } unless defined?(SWIM_VECTORS)

      def act
        action = FISH_ACTIONS.sample
        if action != :stay
          swim_target = actor.position + SWIM_VECTORS[action] * actor.height
          world_pos = coordinates_translator.translate_screen_to_world(swim_target)
          tile = world.occupant_at(world_pos.x, world_pos.y, World::GROUND)
          if tile && tile.actor_type == :water_seed
            actor.update_attributes(x: swim_target.x, y: swim_target.y)
            actor.react_to :oversize
          end

          world_pos = coordinates_translator.translate_screen_to_world(actor.position)
          tile = world.occupant_at(world_pos.x, world_pos.y, World::GROUND)
          actor.remove unless tile
        end
      end
    end
  end
end
