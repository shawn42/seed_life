define_actor :vine_seed do
  has_attributes view: :seed_view
  
  has_behaviors do
    positioned
    layered ZOrder::Seeds
    seed grow_interval: 7_000
    oversize_on_create
    pop_on_create
  end

  behavior do
    requires :world, :planter

    setup do
      reacts_with :grow #, :harvest 
    end

    helpers do
      def range; 8 end
      def grow
        immediate_neighbors = world.occupants_for_box(actor.x-1,actor.y-1,World::GROUND, 2,2)
        unless immediate_neighbors.any?{|neighbor| neighbor.actor_type == :water_seed}

          others = world.occupants_for_box(actor.x - range, actor.y - range, World::GROUND, range, range)
          waters = others.select{|actor| actor.actor_type == :water_seed}

          unless waters.empty?
            # don't think we need the sqrt to see which is closest
            closest = waters.min_by{|w| (actor.x - w.x)*(actor.x - w.x) + (actor.y - w.y)*(actor.y - w.y)}
            unless closest.nil?
              coords = LineOfSite.new(nil).brensenham_line(actor.x.to_i, actor.y.to_i, closest.x.to_i, closest.y.to_i)
              x,y = *coords[1]
              occupant = world.occupant_at(x, y, World::GROUND)
              planter.plant(actor.actor_type, x: x , y: y) unless occupant
            end
          end
        end

      end
    end
  end
end
