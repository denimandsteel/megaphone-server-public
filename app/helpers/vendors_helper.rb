module VendorsHelper

  def neighbourhoods_for_dropdown
    cities_and_neighbourhoods = {
      'Vancouver' => [
        ['Arbutus Ridge', 'arbutus-ridge'],
        ['Downtown', 'downtown'],
        ['Dunbar Southlands', 'dunbar-southlands'],
        ['Fairview', 'fairview'],
        ['Grandview Woodland', 'grandview-woodland'],
        ['Hastings Sunrise', 'hastings-sunrise'],
        ['Kensington Cedar Cottage','kensington-cedar-cottage'],
        ['Kerrisdale', 'kerrisdale'],
        ['Killarney', 'killarney'],
        ['Kitsilano', 'kitsilano'],
        ['Marpole', 'marpole'],
        ['Mount Pleasant', 'mount-pleasant'],
        ['Oakridge', 'oakridge'],
        ['Renfrew Collingwood', 'renfrew-collingwood'],
        ['Riley Park', 'riley-park'],
        ['Shaughnessy', 'shaughnessy'],
        ['South Cambie', 'south-cambie'],
        ['Strathcona', 'strathcona'],
        ['Sunset', 'sunset'],
        ['West End', 'west-end'],
        ['West Point Grey', 'west-point-grey'],
      ],
      'Victoria' => [
        ['Burnside', 'burnside'],
        ['Downtown', 'downtown-victoria'],
        ['Fairfield', 'fairfield'],
        ['Fernwood', 'fernwood'],
        ['Gonzales', 'gonzales'],
        ['Hillside-Quadra', 'hillside-quadra'],
        ['James Bay', 'james-bay'],
        ['Jubilee', 'jubilee'],
        ['North Park', 'north-park'],
        ['Oaklands', 'oaklands'],
        ['Rockland', 'rockland'],
        ['Victoria Fraserview', 'victoria-fraserview'],
        ['Victoria West', 'victoria-west'],
      ]
    }   
  end

  def link_to_add_location(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: 'add-location btn btn-primary', data: {id: id, fields: fields.gsub("\n", "")})
  end

  def vendor_neighbourhoods(vendor)
    vendor.locations.map(&:neighbourhood).uniq.join(", ")
  end

end
