define_behavior :seed do
  requires :stage, :world, :timer_manager, :sound_manager

  # requires_behaviors :highlight_on_grow
  requires_behaviors :oversize_on_create
  setup do
    sound_manager.play_sound :pop
    world.occupy(actor.x, actor.y, actor)

    grow_interval = opts[:grow_interval]
    if grow_interval
      timer_manager.add_timer seed_grow_timer_name, grow_interval do
        actor.react_to :grow
      end
    end
    reacts_with :remove
  end

  helpers do
    def seed_grow_timer_name; "seed_grow_#{object_id}" end
    def remove
      # seeds do not move, so this is safe
      occ = world.occupant_at(actor.x, actor.y)
      world.occupy(actor.x, actor.y, nil) if occ == actor
      timer_manager.remove_timer seed_grow_timer_name
    end
  end
end
