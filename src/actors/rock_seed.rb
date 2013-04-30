define_actor :rock_seed do
  has_attributes color: Color::GRAY,
    view: :seed_view

  has_behaviors do
    positioned
    seed
    oversize_on_create
    pop_on_create
  end
end
