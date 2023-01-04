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
require "test_helper"

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
