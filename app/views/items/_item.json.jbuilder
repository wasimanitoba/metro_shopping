json.cheapest_available item.cheapest_supplier
json.full_name item.full_name
json.year_avg item.year_avg
json.month_avg item.month_avg
json.brand item.brand.titleize if item.brand.present?
json.category item.category.titleize if item.category.present?
json.extract! item, :id
json.url item_url(item, format: :json)
