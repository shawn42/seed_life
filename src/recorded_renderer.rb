# EEWWWW
# how can we handle this more cleanly in gamebox?
class ActorView
  extend Publisher
  can_fire_anything

  def mark_dirty!
    fire :dirty
  end
end

class RecordedRenderer < Renderer
  construct_with :viewport
  attr_accessor :dirty

  def initialize
    super
    @dirty = true
  end

  def register_drawable(drawable)
    drawable.when(:dirty) { @dirty = true }
    super
    @dirty = true
  end


  def unregister_drawable(drawable)
    drawable.unsubscribe_all self
    super
    @dirty = true
  end

  def draw(target)
    center_x = viewport.width / 2
    center_y = viewport.height / 2

    target.rotate(-viewport.rotation, center_x, center_y) do
      if @dirty
        @image = target.record(viewport.width, viewport.height) do
          z = 0
          @parallax_layers.each do |parallax_layer|
            drawables_on_parallax_layer = @drawables[parallax_layer]

            if drawables_on_parallax_layer
              @layer_orders[parallax_layer].each do |layer|

                trans_x = viewport.x_offset parallax_layer
                trans_y = viewport.y_offset parallax_layer

                z += 1
                drawables_on_parallax_layer[layer].each do |drawable|
                  drawable.draw target, trans_x, trans_y, z
                end
              end
            end
          end
        end
        @dirty = false
      end
      target.draw_image @image,0,0,0
    end
  end
end
