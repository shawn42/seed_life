define_actor :rock_seed do
  has_attributes view: :seed_view

  has_behaviors do
    layered ZOrder::Seeds
    positioned
    seed
    oversize_on_create
    pop_on_create
  end
end
