define_stage :grow do
  requires :world

  curtain_up do
    sound_manager.play_music :seeds
    @dirt = create_actor :dirt
    @weed_planter = create_actor :weed_planter, force_weed_every: 30_000
    @planter = create_actor :seed_planter
    @harvester = create_actor :harvester
  end

  # helpers do
  #   include MyHelpers
  #   def help
  #     ...
  #   end
  # end
end
