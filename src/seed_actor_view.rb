define_actor_view :seed_view do
  requires :coordinates_translator

  # TODO gamebox needs to call helpers _before_ setup!
  # helpers do
  #   include MinMaxHelpers
  # end

  setup do
    self.class.send(:include, MinMaxHelpers)
    @original_box = coordinates_translator.translate_world_to_screen actor.position
    @box = @original_box
    @color = actor.color.dup
    @color.value = max(0, min(@color.value+((rand-0.8)/20),1))
    @rndcolors = [@color.dup,@color.dup,@color.dup,@color.dup]
    @rndcolors.each do |c|
      c.value=[0, [@color.value+(rand/20),1].min].max
    end

    h = 10
    @qds = [
      [[0, 0],[h,h]],
      [[h,0],[h*2,h]],
      [[0,h],[h,h*2]],
      [[h,h,h*2,h*2]]
    ]

    actor.when(:position_changed) do
      @original_box = coordinates_translator.translate_world_to_screen actor.position
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
    h = 10
    target.fill @box.x, @box.y, @box.x+h, @box.y+h, @rndcolors[0], z
    target.fill @box.x+h, @box.y, @box.r, @box.y+h, @rndcolors[1], z
    target.fill @box.x, @box.y+h, @box.x+h, @box.b, @rndcolors[2], z
    target.fill @box.x+h, @box.y+h, @box.r, @box.b, @rndcolors[3], z
  end

end

