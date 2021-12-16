class PriceCalculator
  attr_reader :pages, :hours_to_deadline, :academic_level, :spacing

  # default pages: 1, deadline: 3 days, level: college, spacing: double
  def initialize(pages = 1,hours_to_deadline = 72,academic_level = "college", spacing = "double")
    @pages              = pages.to_i
    @hours_to_deadline  = hours_to_deadline.to_i
    @academic_level     = academic_level.downcase
    @spacing            = spacing.downcase
  end

  def cost
    case academic_level
      when "high school" then price_for_highschool * multiplier
      when "college" then price_for_college * multiplier
      when "university" then price_for_university * multiplier
      when "masters" then price_for_masters * multiplier
      when "phd" then price_for_phd * multiplier
    end
  end

  private

  def multiplier
    spacing_x = spacing == "double" ? 1 : 2
    pages * spacing_x
  end

  # 8         - 8 hours
  # 9..24     - 1 day
  # 25..48    - 2 days max
  # 49..72    - 3 days max
  # 73.120    - 5 days max
  # 121..168  - 7 days max
  # Else anything above that

  def price_for_highschool
    case hours_to_deadline
      when proc { |n| n <= 8 } then 24
      when 9..24 then 22
      when 25..48 then 20
      when 49..72 then 18
      when 73..120 then 16
      when 121..168 then 14
      else 12
    end
  end

  def price_for_college
    case hours_to_deadline
      when proc { |n| n <= 8 } then 26
      when 9..24 then 24
      when 25..48 then 22
      when 49..72 then 20
      when 73..120 then 18
      when 121..168 then 16
      else 14
    end
  end

  def price_for_university
    case hours_to_deadline
      when proc { |n| n <= 8 } then 28
      when 9..24 then 26
      when 25..48 then 24
      when 49..72 then 22
      when 73..120 then 20
      when 121..168 then 18
      else 16
    end
  end

  def price_for_masters
    case hours_to_deadline
      when proc { |n| n <= 8 } then 30
      when 9..24 then 28
      when 25..48 then 26
      when 49..72 then 24
      when 73..120 then 22
      when 121..168 then 20
      else 18
    end
  end

  def price_for_phd
    case hours_to_deadline
      when proc { |n| n <= 24 } then 35
      when 25..48 then 33
      when 49..72 then 31
      when 73..120 then 29
      when 121..168 then 27
      else 25
    end
  end
end
