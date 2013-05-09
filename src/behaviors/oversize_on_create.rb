define_behavior :oversize_on_create do

  requires :director

  setup do
    actor.has_attributes inflate_by: 10
    actor.has_attributes oversize_tween: Tween.new(actor.inflate_by, 2, Tween::Elastic::Out, 300)

    director.when :update do |t_ms|
      actor.oversize_tween.update t_ms
      actor.inflate_by = actor.oversize_tween.value

      if actor.oversize_tween.done
        actor.inflate_by = 0
        # actor.remove_behavior :oversize_on_create
      end
    end

    reacts_with :remove, :oversize
  end

  helpers do
    def remove
      director.unsubscribe_all self
    end

    def oversize
      actor.inflate_by = 5
      actor.oversize_tween = Tween.new(actor.inflate_by, 2, Tween::Elastic::Out, 300)
    end
  end
end
