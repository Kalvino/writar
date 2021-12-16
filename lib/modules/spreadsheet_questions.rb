class SpreadsheetQuestions
  attr_reader :session, :key

  def initialize
    @session = GoogleDrive::Session.from_config("config/gconf.json")
    @key     = "1h9u8e0Wk25N7iiLyjBv6xn3zMxrBC90wZJd5MU55gfM"
  end

  def import
    ws = session.spreadsheet_by_key(key).worksheets[0]
    headers = [:title, :content]

    (2..ws.num_rows).each do |row|
      record = {}
      (1..ws.num_cols).each do |col|
        if col == 3
          next if ws[row, col] == "Imported" # skip imported records
          ws[row, col] = "Imported"
        else
          record[headers[col-1]] = ws[row, col]
        end
      end
      record[:title] = record[:title][0..230]
      question = Question.create(record)
      if question.save
        ws.save
        puts "=> * Created question: #{question.title}"
      else
        SlackBot.notify("Spreadsheet Import Error", "error", question.errors.full_messages.join(","))
      end
    end
  end
end
