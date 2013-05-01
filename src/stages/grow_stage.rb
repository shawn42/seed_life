SEED_COLORS = {
  rock_seed: Color::GRAY,
  bush_seed: Color.argb(0xFF74BAAC),
  flower_seed: Color.argb(0xFF7979FF),
  tree_seed: Color.argb(0xFF59955C),
  vine_seed: Color.argb(0xFF5EAE9E),
  water_seed: Color.argb(0xFF00BFFF),
  weed_seed: Color.argb(0xFFFF5353),
}

define_stage :grow do
  render_with :recorded_renderer
  requires :world

  curtain_up do
    sound_manager.play_music :seeds, repeat: true
    @dirt = create_actor :dirt
    @weed_planter = create_actor :weed_planter, force_weed_every: 30_000
    @seed_planter = create_actor :seed_planter
    @cloud_planter = create_actor :cloud_planter
    @harvester = create_actor :harvester
    input_manager.reg(:down, KbF1) { @fps = create_actor :fps, x: 800, y: 10 }
    input_manager.reg(:down, KbF2) { @fps.remove if @fps }
  end

  # helpers do
  #   include MyHelpers
  #   def help
  #     ...
  #   end
  # end
end

