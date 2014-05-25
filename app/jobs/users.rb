class UserJob
  include Resque::Plugins::Status

  def perform
    puts "Parsing CSV and updating..."
    parse_csv
    puts "Update finished..."
  end

  def parse_csv
    @counter = 0 
    @row = []
    csv_text = File.open("#{Rails.public_path}/careersfair.csv", "r:ISO-8859-1")
    csv = CSV.parse(csv_text, headers: false)
    csv.each do |row|
      puts row[3]
      user = User.find_by_email row[3].to_s.downcase
      if user.present?
        user.update(:first_name => row[0], :last_name => row[1], :industry => row[2], :skip_invitation => true) 
        puts @counter += 1
      else
        puts "Not found - #{row[3]}"
      end
    end
  end
end