class AddCounterCacheToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :essays_count, :integer, default: 0
    Seller.find_each { |seller| Seller.reset_counters(seller.id, :essays) }
  end
end
