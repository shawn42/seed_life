define_actor_view :seed_view do
  requires :coordinates_translator

  draw do |target, x_off, y_off, z|
    box = coordinates_translator.translate_world_to_screen actor.position
    if actor.do_or_do_not(:inflate_by)
      box.inflate!(actor.inflate_by, actor.inflate_by)
    end

    color = actor.color
    if actor.do_or_do_not(:fade_by)
      color = Color.argb(color.alpha - actor.fade_by, color.red, color.green, color.blue)
    end
    target.fill box.x, box.y, box.r, box.b, color, ZOrder::Seeds
  end
end

