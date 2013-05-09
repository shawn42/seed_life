define_actor_view :critter_view do
  requires :coordinates_translator

  setup do
    @color = actor.color
    @original_box = Rect.new(actor.x, actor.y, actor.width, actor.height)
    @box = @original_box
    actor.when(:position_changed) do
      @original_box = Rect.new(actor.x, actor.y, actor.width, actor.height)
      @box = @original_box
      mark_dirty! 
    end
    actor.when(:inflate_by_changed) do
      @box = @original_box.inflate(actor.inflate_by, actor.inflate_by)
      mark_dirty!
    end
    actor.when(:fade_by_changed) do
      c = actor.color
      @color = Color.argb(c.alpha - actor.fade_by, c.red, c.green, c.blue)
      mark_dirty!
    end
  end

  draw do |target, x_off, y_off, z|
    target.fill @box.x, @box.y, @box.r, @box.b, @color, z
  end

end

