define_behavior :oversize_on_create do

  requires :director

  setup do
    actor.has_attributes inflate_by: 10
    actor.has_attributes oversize_tween: Tween.new(actor.inflate_by, 2, Tween::Elastic::Out, 300)

    director.when :update do |t_ms|
      if actor.oversize_tween 
        actor.inflate_by = actor.oversize_tween.value

        if actor.oversize_tween.done
          actor.oversize_tween = nil
          actor.inflate_by = 0
        else
          actor.oversize_tween.update t_ms
        end
      end
    end

    reacts_with :remove
  end

  helpers do
    def remove
      director.unsubscribe_all self
    end
  end
end
