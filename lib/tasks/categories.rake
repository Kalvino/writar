namespace :db do
  namespace :categories do

    desc "Import categories"
    task :import => :environment do
      categories = ['International Relations', 'Accounting', 'Anthropology', 'Application Letters', 'Architecture, Building and Planning',
                    'Art (Fine arts, Performing arts)', 'Astronomy (and other Space Sciences)', 'Aviation', 'Biology and other Life Sciences',
                    'Business Studies', 'Chemistry', 'Civil Engineering', 'Classic English Literature', 'Communications', 'Composition',
                    'Computer science', 'Criminal Justice', 'Criminal law', 'Cultural and Ethnic Studies', 'Ecology', 'Economics',
                    'Education', 'Engineering', 'English 101', 'Environmental studies and Forestry', 'Ethics', 'Family and consumer science',
                    'Film and Theater studies', 'Finance', 'Geography', 'Geology (and other Earth Sciences)', 'Health Care', 'History',
                    'Human Resources Management (HRM)', 'Web', 'IT, Web', 'Agriculture', 'International Trade', 'Law', 'Leadership Studies',
                    'Linguistics', 'Literature', 'Logistics', 'Management', 'Marketing', 'Mathematics', 'Medical Sciences (Anatomy, Physiology, Pharmacology etc.)',
                    'Medicine', 'Music', 'Nursing', 'Nutrition/Dietary', 'Women and gender studies', 'Philosophy', 'Physics', 'Poetry', 'Political science',
                    'Psychology', 'Public Administration', 'Public Relations (PR)', 'Religious studies', 'Shakespeare', 'Social Work and Human Services',
                    'Sociology', 'Sports', 'Statistics', 'Technology', 'Tourism', 'Urban Studies', 'Zoology', 'Other']
      categories.each do |cat|
        category = Category.where(name: cat).first_or_create!
        puts "=> Category created: #{category.name}"
      end
    end
  end
end