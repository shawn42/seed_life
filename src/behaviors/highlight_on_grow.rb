define_behavior :highlight_on_grow do

  requires :director

  setup do
    actor.has_attributes color: Color::WHITE,
      grow_tween: nil

    director.when :update do |t_ms|
      if actor.grow_tween 
        alpha_value = actor.grow_tween.value
        c = actor.color
        actor.color = Color.argb(alpha_value, c.red, c.green, c.blue)

        if actor.grow_tween.done
          actor.grow_tween = nil
        else
          actor.grow_tween.update t_ms
        end
      end
    end

    reacts_with :grow, :remove
  end

  helpers do
    def grow
      actor.grow_tween = Tween.new(150, 255, Tween::Elastic::Out, 1000)
    end

    def remove
      director.unsubscribe_all self
    end
  end
end
