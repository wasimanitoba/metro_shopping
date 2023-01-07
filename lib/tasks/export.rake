namespace :export do
  desc "Export users"
  task :seeds => :environment do
    Store.all.each do |store|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = store.serializable_hash.delete_if{|key,value| excluded_keys.include?(key) }

      puts("Store.create(#{serialized})")
    end

    Item.all.each do |item|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = item.serializable_hash.delete_if{|key,value| excluded_keys.include?(key) }

      puts("Item.create(#{serialized})")
    end

    Package.all.each do |package|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = package.serializable_hash.delete_if{|key,value| excluded_keys.include?(key) }

      puts("Package.create(#{serialized})")
    end

    Purchase.all.each do |purchase|
      excluded_keys = ['created_at', 'updated_at', 'id']
      serialized = purchase.serializable_hash.delete_if{|key,value| excluded_keys.include?(key) }

      serialized['date'] = serialized['date'].to_s.split('-').map(&:to_i)

      puts("Purchase.create(#{serialized})")
    end
  end
end