class CoordinatesTranslator
  CELL_SIZE = 20

  def translate_world_to_screen(position)
    trans_pos = position * CELL_SIZE
    Rect.new trans_pos.x, trans_pos.y, CELL_SIZE, CELL_SIZE
  end

  def translate_screen_to_world(position)
    # integer math intentional
    vec2(position.x.round/CELL_SIZE, position.y.round/CELL_SIZE)
  end

end
