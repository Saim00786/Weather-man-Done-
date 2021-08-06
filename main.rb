# frozen_string_literal: true

require "./weatherman.rb"

mode = ARGV[0]
year_or_month = ARGV[1]
path = ARGV[2]

if !File.directory?(path)
  puts 'Path does not exist.'
  exit
end

if !year_or_month.split('/')[1].to_i.between?(1,12)
  puts "Enter a month between 1 - 12"
  exit
end

w1 = Weatherman.new

files = w1.get_filenames(path,year_or_month)
month = year_or_month.split('/')[1]
filename = files.select { |file| file.include? Date::MONTHNAMES[month.to_i][0..2] }[0]

if files.empty?
  puts 'Year does not exist.'
  exit
end

if filename.nil?
  puts 'Month data not available.'
  exit
end



if mode == '-e'

  max_temp, max_date, min_temp, min_date, max_humidity, max_humidity_date = w1.mode_e(files, path)

  puts "Highest: #{max_temp}C on #{Date.parse(max_date).strftime('%A')} #{Date.parse(max_date).day} "
  puts "Lowest: #{min_temp}C on #{Date.parse(min_date).strftime('%A')} #{Date.parse(min_date).day} "
  puts "Humid: #{max_humidity}% on #{Date.parse(max_humidity_date).strftime('%A')} #{Date.parse(max_humidity_date).day} "

elsif mode == '-a'

  tmp = w1.mode_a(filename, path)

  puts "Highest Average: #{tmp[0]}C"
  puts "Lowest Average: #{tmp[1]}C"
  puts "Average Humidity: #{tmp[2]}%"

elsif mode == '-c'
  year, month = year_or_month.split('/')
  month_name = Date::MONTHNAMES[month.to_i]
  puts "#{month_name} #{year}"
  w1.draw_lines(filename, path)

else
  puts "Invalid option #{mode} not available."
end