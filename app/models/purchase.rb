# == Schema Information
#
# Table name: purchases
#
#  id             :bigint           not null, primary key
#  cost           :decimal(, )      not null
#  date           :date             not null
#  discount       :decimal(, )      default(0.0)
#  price          :decimal(, )      not null
#  price_per_unit :decimal(, )
#  quantity       :integer          default(1), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  package_id     :bigint           not null
#  store_id       :bigint           not null
#
# Indexes
#
#  index_purchase_on_store_id     (store_id)
#  index_purchases_on_package_id  (package_id)
#
# Foreign Keys
#
#  fk_rails_...  (package_id => packages.id)
#  fk_rails_...  (store_id => stores.id)
#
class Purchase < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :package
  belongs_to :store

  accepts_nested_attributes_for :store, :package

  validates :price, presence: true
  validates :date, presence: true


  before_save do
    self.price_per_unit = (price.to_f / package.measurement) / quantity

    self.cost = price if self.cost.blank?
  end

  scope :cheapest, -> { order(:price_per_unit, :date).limit(1) }

  delegate :to_s, to: :package

  def self.js_columns
    table_columns = [
      { title: 'Item', field: 'package', sorter: 'string' },
      { title: 'Total Price ($)', field: 'price', sorter: 'number' },
      { title: 'Price ($) Per Unit', field: 'unit_cost_label', sorter: 'number' },
      { title: 'Store', field: 'store', sorter: 'string' },
      { title: 'Purchase Date', field: 'date', sorter: 'string' }
    ]

    JSON.generate(table_columns)
  end

  # price_per_unit isn't very meaningful on it's own without a label
  def unit_cost_label
    default_price = number_to_currency(price_per_unit)

    return "#{default_price} per #{package.measurement_unit}" # unless price_per_unit < 0.01

    # "#{number_to_currency(price_per_unit * 100)} per 100 #{package.measurement_unit}"
  end

  def amount
    return package.amount unless quantity > 1

    "#{package.amount} <br> (Quantity: #{quantity})"
  end

  def formatted(qty = nil)
    selected_quantity = qty || quantity

    "#{package.amount(selected_quantity)} <br> Total Price: #{number_to_currency(price * selected_quantity)}".html_safe
  end
end
