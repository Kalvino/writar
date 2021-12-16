class AddCounterCacheToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :essays_count, :integer, default: 0
    Category.find_each { |category| Category.reset_counters(category.id, :essays) }
  end
end
