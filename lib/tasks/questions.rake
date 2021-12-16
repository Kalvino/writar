namespace :questions do
  desc "Deletes questions marked denied"
  task :cleanup => :environment do
    puts "=> * Deleting #{Question.denied.count} denied questions"
    Question.denied.map(&:destroy)
  end
end
