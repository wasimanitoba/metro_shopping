# == Schema Information
#
# Table name: items
#
#  id                    :bigint           not null, primary key
#  brand                 :string
#  category              :string
#  filterable_attributes :string
#  name                  :string           not null
#  picture               :string
#
class Item < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  serialize :filterable_attributes, Hash

  has_many :packages
  has_many :purchases, through: :package
  before_save :downcase

  def historical_price_difference; end
  def recent_price_collection; end

  def monthly_prices
    history = purchases.where(date: 1.year.ago..Date.current).group_by do |purchase|
      DateTime::ABBR_MONTHNAMES.compact[purchase.date.month - 1]
    end

    price_list = DateTime::ABBR_MONTHNAMES.compact.map do |month|
      prices_for_the_month = history[month]

      next(nil) if prices_for_the_month.blank?

      prices_for_the_month.sum(&:price) / prices_for_the_month.size
    end

    JSON.generate(price_list.as_json)
  end

  def purchases
    Purchase.where(package_id: package_ids)
  end

  def series
    purchases.group(:store).order(1).average(:price_per_unit)
  end

  def series_values
    series.values.as_json
  end

  def series_keys
    series.keys.map(&:name).as_json
  end

  def deals(limit: 3)
    purchases.order(:price_per_unit, :date).limit(limit)
  end

  def cheapest
    deals.first
  end

  def downcase
    self.name     = name.downcase
    self.brand    = brand.downcase if brand.present?
    self.category = category.downcase if category.present?
  end

  def other_suppliers
    store_names  = purchases.map { |purchase| purchase.store.name }
    return unless cheapest.present?

    non_cheapest = store_names.uniq - [cheapest.store.name]

    non_cheapest.join(' | ')
  end

  def self.listings
    listing_array = all.map do |item|
      item_packages_ary = item.packages.map do |package|
        { label: package.select_label, value: package }
      end

      { label: item.full_name, options: item_packages_ary }
    end

    JSON.generate(listing_array)
  end

  def to_s
    name.titleize
  end

  # Combined table uses the hardcoded columns
  def self.js_columns
    JSON.generate(self.hardcoded_columns)
  end

  # Tables for an individual item instance use the item-specific attributes
  def js_columns(with_package: false)
    valid_columns  = self.class.hardcoded_columns
    valid_columns += [filterable_attributes] unless filterable_attributes.empty?
    valid_columns += Package.js_columns if with_package

    JSON.generate(valid_columns)
  end


  def self.hardcoded_columns
    [
      { title: "Product", field: "full_name", sorter: "string" },
      { title: "Category", field: "category", sorter: "string" },
      { title: "Cheapest Supplier", field: "cheapest_available", sorter: "string" },
      { title: "Average this Month", field: "month_avg", sorter: "number" },
      { title: "Average this Year", field: "year_avg", sorter: "number" }
    ]
  end

  def full_name
    "#{brand} #{name}".titleize
  end

  def cheapest_supplier
    return '' if purchases.empty?

    purchase = purchases.order(:price_per_unit, :date).limit(1).first

    "#{purchase.store.name} - [#{purchase.unit_cost_label}]"
  end

  def month_avg
    blank_or_dollars purchases.where(date: (1.month.ago..Date.current)).average(:price)
  end

  def year_avg
    blank_or_dollars purchases.where(date: (1.year.ago..Date.current)).average(:price)
  end

  def blank_or_dollars(possibly_nil_amount_value)

    return '-' if possibly_nil_amount_value.blank?

    number_to_currency(possibly_nil_amount_value)
  end
end
