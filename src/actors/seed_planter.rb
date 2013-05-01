define_actor :seed_planter do
  has_behaviors do
    layered ZOrder::Hud
  end

  behavior do
    requires :world, :input_manager, :planter, :coordinates_translator
    
    setup do
      actor.has_attributes current_seed: :rock_seed, planting: false,
        straight_lines: false, last_planted: nil, line_on_axis: nil, x: 10, y: 10

      # TODO loop over seed types?
      input_manager.reg(:down, Kb1) { change_seed_to :rock_seed }
      input_manager.reg(:down, Kb2) { change_seed_to :water_seed }
      input_manager.reg(:down, Kb3) { change_seed_to :bush_seed }
      input_manager.reg(:down, Kb4) { change_seed_to :vine_seed }
      input_manager.reg(:down, Kb5) { change_seed_to :tree_seed }
      input_manager.reg(:down, Kb6) { change_seed_to :flower_seed }
      input_manager.reg(:down, Kb0) { change_seed_to :weed_seed }

      input_manager.while_pressed([KbLeftShift, KbRightShift], actor, :straight_lines)

      input_manager.reg :mouse_down, MsLeft do |event|
        pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
        planter.plant(actor.current_seed, x: pos.x, y: pos.y) unless world.occupant_at?(pos.x,pos.y, World::GROUND)
        actor.last_planted = pos.dup
        actor.planting = true
      end

      input_manager.reg :mouse_motion do |event|
        if actor.planting?
          pos = coordinates_translator.translate_screen_to_world(vec2(*event[:data]))
          if pos != actor.last_planted

            if actor.straight_lines?
              unless actor.line_on_axis?
                line = pos - actor.last_planted
                if line.x.abs > line.y.abs
                  actor.line_on_axis = :y
                else
                  actor.line_on_axis = :x
                end
              end

              if actor.line_on_axis == :y
                pos.y = actor.last_planted.y
              else
                pos.x = actor.last_planted.x
              end
            else
              actor.last_planted = pos.dup
            end

            planter.plant(actor.current_seed, x: pos.x, y: pos.y) unless world.occupant_at?(pos.x,pos.y, World::GROUND)
          end
        end
      end

      input_manager.reg(:mouse_up, MsLeft) { 
        actor.planting = false 
        actor.line_on_axis = nil
      }

      reacts_with :remove
    end

    helpers do
      def change_seed_to(seed_type)
        actor.current_seed = seed_type
      end

      def remove
        input_manager.unsubscribe_all self
      end
    end

  end

  view do
    requires :font_style_factory

    setup do
      @font = font_style_factory.build("Asimov.ttf", 30, Color::WHITE)

      @bg_color = Color.argb(0x99222222)
      actor.when(:current_seed_changed) do
        @seed_color = SEED_COLORS[actor.current_seed]
        mark_dirty! 
      end
      @seed_color = SEED_COLORS[actor.current_seed]
    end

    draw do |target, x_off, y_off, z|
      target.fill(actor.x, actor.y, actor.x+150, actor.y+50, @bg_color, z)
      box = Rect.new(actor.x+10, actor.y+10, 30, 30)
      target.fill(box.x, box.y, box.r, box.b, @seed_color, z)
      target.print(actor.current_seed.to_s.gsub('_seed','').upcase, actor.x+50, actor.y+10, z, @font)
    end
  end
end
