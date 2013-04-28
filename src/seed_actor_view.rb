define_actor_view :seed_view do
  requires :coordinates_translator

  draw do |target, x_off, y_off, z|
    box = coordinates_translator.translate_world_to_screen actor.position
    box.inflate!(actor.inflate_by, actor.inflate_by)
    target.fill box.x, box.y, box.r, box.b, actor.color, ZOrder::Seeds
  end
end

