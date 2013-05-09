define_behavior :critter do
  requires :timer_manager, :world
  setup do
    actor.has_attributes color: CRITTER_COLORS[actor.actor_type],
      width: (CoordinatesTranslator::CELL_SIZE / 2), 
      height: (CoordinatesTranslator::CELL_SIZE / 2)

    world.add_critter(actor)

    act_interval = opts[:act_interval]
    if act_interval
      timer_manager.add_timer critter_act_timer_name, act_interval do
        actor.react_to :act
      end
    end
    reacts_with :remove
  end

  helpers do
    def critter_act_timer_name; "critter_act_#{object_id}" end
    def remove
      world.remove_critter(actor)
      timer_manager.remove_timer critter_act_timer_name
    end
  end
end
