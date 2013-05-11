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
    create_actor(:icon, image: "grain.png", x: 512, y: 400, layer: ZOrder::Noise)

    @dirt = create_actor :dirt
    @weed_planter = create_actor :weed_planter, force_weed_every: 30_000
    @seed_planter = create_actor :seed_planter
    @cloud_planter = create_actor :cloud_planter
    @harvester = create_actor :harvester
    @critter_creator = create_actor :critter_creator

    input_manager.reg(:down, KbF1) { @fps = create_actor :fps, x: 800, y: 10 }
    input_manager.reg(:down, KbF2) { @fps.remove if @fps }
    # input_manager.reg(:down, KbF3) { binding.pry }
  end

  # helpers do
  #   include MyHelpers
  #   def help
  #     ...
  #   end
  # end
end

class TimerManager

  def add_timer(name, interval_ms, recurring = true, &block)
    # log "add_timer: #{name}"
    raise "timer [#{name}] already exists" if @timers[name]
    # log "timers size: #{@timers.size}"
    @timers[name] = {
      count: 0, recurring: recurring,
      interval_ms: interval_ms, callback: block}
  end

  def remove_timer(name)
    # log "remove_timer: #{name} #{caller[0..9]}"
    @timers.delete name
  end
  
end

# Directors manage actors.
class Director

  def clear_subscriptions
    @subscriptions = Hash[@update_slots.map { |slot| [slot, []] }]
    @new_subscriptions = []
    @unsubscriptions = []
  end

  def when(event=:update, &callback)
    @new_subscriptions << [event, callback]
  end

  def update(time)
    @new_subscriptions.each do |(event, callback)|
      @subscriptions[event] ||= []
      @subscriptions[event] << callback
    end
    @new_subscriptions.clear

    @unsubscriptions.each do |listener|
      for slot in @subscriptions.keys
        @subscriptions[slot].delete_if do |block|
          eval('self',block.binding).equal?(listener)
        end
      end
    end
    @unsubscriptions.clear

    time_in_seconds = time / 1000.to_f
    @update_slots.each do |slot|
      @subscriptions[slot].each do |callback|
        callback.call time, time_in_seconds
      end
    end

  end

  def unsubscribe_all(listener)
    @unsubscriptions << listener
  end

end
class Vector2
  def ==( vector )
    # TODO add this nil check to gamebox
    return false if vector.nil?
    _nearly_equal?(@x, vector.at(0)) and _nearly_equal?(@y, vector.at(1))
  end
end

