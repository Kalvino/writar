every 1.day, :at => '1:00 am' do
  rake "sitemap:refresh", output: "log/sitemap.log"
  rake "questions:cleanup", output: "log/questions_cleaner.log"
end

every 1.day, :at => '12:00 am' do
  command "backup perform -t db_backup", output: '/home/admin/apps/papersmarketplace/log/backup.log'
end
