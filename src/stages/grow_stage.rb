define_stage :grow do
  requires :world

  curtain_up do
    sound_manager.play_music :seeds, repeat: true
    @dirt = create_actor :dirt
    @weed_planter = create_actor :weed_planter, force_weed_every: 30_000
    @seed_planter = create_actor :seed_planter
    @cloud_planter = create_actor :cloud_planter
    @harvester = create_actor :harvester
    input_manager.reg(:down, KbF1) { create_actor :fps, x: 800, y: 10 }
  end

  # helpers do
  #   include MyHelpers
  #   def help
  #     ...
  #   end
  # end
end
