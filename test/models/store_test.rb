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
require "test_helper"

class StoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
