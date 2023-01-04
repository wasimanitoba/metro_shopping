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
require "test_helper"

class PurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
