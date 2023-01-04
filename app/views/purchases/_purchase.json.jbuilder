json.package purchase.package.to_s
json.store purchase.store.name
json.price purchase.formatted
json.unit_cost_label purchase.unit_cost_label
json.extract! purchase, :id, :amount, :date, :to_s
json.url purchase_url(purchase, format: :json)
