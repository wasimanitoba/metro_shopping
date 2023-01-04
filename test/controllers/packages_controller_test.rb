require "test_helper"

class PackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @package = packages(:one)
  end

  test "should get index" do
    get packages_url
    assert_response :success
  end

  test "should get new" do
    get new_package_url
    assert_response :success
  end

  test "should create package" do
    assert_difference("Package.count") do
      post packages_url, params: { package: { item: { id: @package.item_id }, measurement: @package.measurement, measurement_units: @package.measurement_units } }
    end

    assert_redirected_to package_url(Package.last)
  end

  test "should show package" do
    get package_url(@package)
    assert_response :success
  end

  test "should get edit" do
    get edit_package_url(@package)
    assert_response :success
  end

  test "should update package" do
    patch package_url(@package), params: { package: { item_id: @package.item_id, measurement: @package.measurement, measurement_units: @package.measurement_units } }
    assert_redirected_to package_url(@package)
  end

  test "should destroy package" do
    assert_difference("Package.count", -1) do
      @package.purchases.each do |purchase|
        delete purchase_url(purchase)
      end

      delete package_url(@package)
    end

    assert_redirected_to packages_url
  end
end
