json.cheapest_available package.item.cheapest_supplier
json.full_name package.to_s
json.year_avg package.item.year_avg
json.month_avg package.item.month_avg
json.brand package.item.brand.titleize if package.item.brand.present?
json.category package.item.category.titleize if package.item.category.present?
json.extract! package, :id, :measurement_units, :measurement
json.url package_url(package, format: :json)
