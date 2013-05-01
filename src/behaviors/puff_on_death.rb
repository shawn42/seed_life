define_behavior :puff_on_death do

  requires :director

  setup do
    actor.has_attributes inflate_by: 0, fade_by: 0
    reacts_with :remove, :disperse
  end

  helpers do
    def disperse
      actor.has_attributes puff_tween: Tween.new([4,0], [-15, 100], Tween::Elastic::In, 200)
      director.when :update do |t_ms|
        actor.puff_tween.update t_ms
        actor.inflate_by = actor.puff_tween[0]
        actor.fade_by = actor.puff_tween[0]

        if actor.puff_tween.done
          actor.remove
        end
      end
    end

    def remove
      director.unsubscribe_all self
    end
  end
end
