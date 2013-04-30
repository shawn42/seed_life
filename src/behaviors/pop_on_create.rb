define_behavior :pop_on_create do

  requires :sound_manager

  setup do
    sound_manager.play_sound :pop
  end
end
