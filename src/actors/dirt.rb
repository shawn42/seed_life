define_actor :dirt do
  has_attributes layered: ZOrder::Dirt
  view do
    draw do |screen, x_off, y_off, z|
      screen.fill_screen Color.argb(0xFFdcc05e), z
    end
  end
end
