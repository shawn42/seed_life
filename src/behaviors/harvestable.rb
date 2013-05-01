define_behavior :harvestable do

  setup do
    reacts_with :harvest
  end

  helpers do
    def harvest
      actor.remove
    end
  end
end
