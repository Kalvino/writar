task :update_owner_types => :environment do
  Essay.where(owner_type: "User").update_all(owner_type: 'Seller')
  Transaction.where(owner_type: "User").update_all(owner_type: 'Seller')
end