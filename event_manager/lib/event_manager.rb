require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_numbers(phone_number)
  phone_number.to_s.gsub!(/\D/, "")
  if phone_number.length < 10
    phone_number = "0"
  elsif phone_number.length > 10 && phone_number[0] == "1"
    phone_number.sub!(phone_number[0], "")
  elsif phone_number.length > 10 && phone_number[0] != "1"
    phone_number = "0"
  elsif phone_number.length > 10
    phone_number = "0"
  end
end

def time_targeting(datetime)
  array_of_hours = []
  hash_of_hours = {}
  datetime = DateTime.strptime(datetime, "%D %H:%M")
  array_of_hours.push(datetime.hour)
  hash_of_hours[datetime.hour] = array_of_hours.count(datetime.hour)
  datetime = datetime.strftime("Date is: %Y%m%d; Time is: %H:%M; peak registration time is: #{hash_of_hours.key(hash_of_hours.values.max)}")
end

puts "EventManager initialized."

contents = CSV.open 'event_attendees.csv', headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)

  clean_phone_numbers(row[:homephone])

  time_targeting(row[:regdate])

  puts row
end