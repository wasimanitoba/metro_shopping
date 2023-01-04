module PurchasesHelper
  def item_packages
    Item.all.map do |item|
      sub_select_options = item.packages.map.to_h { |package| [package.select_label, package.id] }

      [item.to_s, sub_select_options]
    end
  end
end
