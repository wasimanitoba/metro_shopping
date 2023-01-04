# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  deleted    :boolean          default(FALSE)
#  location   :point
#  name       :string           not null
#  owner      :string
#  place      :string
#  created_at :datetime         not null
#
class Store < ApplicationRecord
  has_many :purchases

  def to_s
    "#{name} #{place}"
  end

  def self.listings
    JSON.generate all.map.to_h { |store| [store.name, store.to_s] }
  end
end
