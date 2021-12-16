module OrdersHelper
  def options_for_academic_level
    [
        ["High School","high school"], ["College","college"], ["University","university"], ["Master's", "masters"],
        ["PhD", "phd"]
    ]
  end

  def options_for_paper_type
    ["Essay (any type)", "Admission essay", "Annotated bibliography", "Argumentative essay", "Article review",
     "Biographies", "Book/movie review", "Business plan", "Capstone project", "Case study", "Coursework",
     "Creative writing", "Critical thinking", "Editing", "Formatting", "Other", "Paraphrasing", "Presentation or speech",
     "Problem solving", "Proofreading", "Research paper", "Research proposal", "Term paper"]
  end

  def options_for_discipline
    ["Accounting", "Agriculture", "Anthropology", "Application Letters", "Architecture, Building and Planning",
     "Art (Fine arts, Performing arts)", "Astronomy (and other Space Sciences)", "Aviation", "Biology (and other Life Sciences)",
     "Business Studies", "Chemistry", "Civil Engineering", "Classic English Literature", "Communications", "Composition",
     "Computer science", "Criminal Justice", "Criminal law", "Cultural and Ethnic Studies", "Ecology", "Economics",
     "Education", "Engineering", "English 101", "Environmental studies and Forestry", "Ethics", "Family and consumer science",
     "Film & Theater studies", "Finance", "Geography", "Geology (and other Earth Sciences)", "Health Care", "History",
     "Human Resources Management (HRM)", "International Relations", "International Trade", "IT, Web", "Law",
     "Leadership Studies", "Linguistics", "Literature", "Logistics", "Management", "Marketing", "Mathematics",
     "Medical Sciences (Anatomy, Physiology, Pharmacology etc.)", "Medicine", "Music", "Nursing", "Nutrition/Dietary",
     "Other", "Philosophy", "Physics", "Poetry", "Political science", "Psychology", "Public Administration",
     "Public Relations (PR)", "Religious studies", "Shakespeare", "Social Work and Human Services", "Sociology",
     "Sports", "Statistics", "Technology", "Tourism", "Urban Studies", "Women's and gender studies", "Zoology"]
  end

  def options_for_citation_style
    ["MLA", "APA", "Chicago","Harvard", "Turabian", "N/A", "Other"]
  end

  def options_for_spacing
    [["Single Spaced", "single"],["Double Space","double"]]
  end

  def options_for_deadline
    [
        ["8 hours", 8],
        ["24 hours", 24],
        ["48 hours", 48],
        ["3 days", 72],
        ["5 days", 120],
        ["7 days", 168],
        ["14 days", 336]
    ]
  end

  def label_for_order(order)
    case order.status
      when "pending_quote" then '<span class="label label-info">Pending Quote</span>'
      when "pending_payment" then '<span class="label label-warning">Pending Payment</span>'
      when "in_progress" then '<span class="label label-success">In Progress</span>'
      when "completed" then '<span class="label label-primary">Completed</span>'
      when "cancelled" then '<span class="label label-danger">Cancelled</span>'
    end
  end
end
