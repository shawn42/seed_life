define_actor_view :seed_view do
  requires :coordinates_translator

  setup do
    @original_box = coordinates_translator.translate_world_to_screen actor.position
    @box = @original_box
    @color = actor.color

    actor.when(:inflate_by_changed) do
      @box = @original_box.inflate(actor.inflate_by, actor.inflate_by)
    end
    actor.when(:fade_by_changed) do
      c = actor.color
      @color = Color.argb(c.alpha - actor.fade_by, c.red, c.green, c.blue)
    end
  end

  draw do |target, x_off, y_off, z|
    target.fill @box.x, @box.y, @box.r, @box.b, @color, z
  end

end

