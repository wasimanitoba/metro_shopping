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
require "test_helper"

class ItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
