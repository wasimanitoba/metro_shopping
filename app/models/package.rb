# == Schema Information
#
# Table name: packages
#
#  id                :bigint           not null, primary key
#  measurement       :decimal(, )
#  measurement_units :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  item_id           :bigint           not null
#
# Indexes
#
#  index_packages_on_item_id  (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#
class Package < ApplicationRecord
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::NumberHelper

  has_many :purchases

  belongs_to :item

  scope :with_items, -> { joins('JOIN items on items.id = packages.item_id') }

  scope :find_by_item_and_measurement, -> (item_package, measurement_amount: nil) do
    # removing the break and anything that follows allows us to accept the to_s value as a filter value
    item_name, measurement_amount = item_package.split('<br>') if item_package.include?('<br>')

    matching_packages = with_items.where(items: { name: item_name.downcase })

    matching_packages.detect { |pkg| pkg.amount == measurement_amount }
  end

  def self.js_columns
    [ { title: "Amount", field: "amount", sorter: "string" } ]
  end

  def amount
    number_to_human(measurement, units: measurement_units)
  end

  # changing this affects the implementation of Package.find_by_item_and_measurement
  def to_s
    [item.name.titleize, amount].join(tag.br).html_safe
  end

  def select_label
    "#{item} [#{amount}]"
  end

  # The units set by user at time of submitting data
  enum measurement_units: %i[ weight volume ]

  def measurement_unit
    measurement_units == 'weight' ? 'kilogram' : 'litre'
  end
end
