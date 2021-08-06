require 'date'
require 'colorize'

class Weatherman

  def get_filenames(path, year_or_month)
    files = []
    if !path.nil?
      files = Dir.entries(path)
      files.delete_at(0)
      files.delete_at(0)
    else
      puts 'path was not provided.'
      exit
    end
    files.select { |name| name.include? year_or_month.split('/')[0]}
  end

  def mode_e(files, path)
    min = 999
    max = max_humidity = 0
    max_date = min_date = max_humidity_date = ''
    files.each do |filename|
      file = File.open("#{path}/#{filename}", 'r')
      lines = file.read.split("\n").select { |line| line.include? ',' }
      lines.delete_at(0)
      lines.each do |line|
          max, max_date = line.split(',')[1].to_i, line.split(',')[0] if max < line.split(',')[1].to_i
          min, min_date = line.split(',')[3].to_i, line.split(',')[0] if min > line.split(',')[1].to_i
          max_humidity, max_humidity_date = line.split(',')[7].to_i, line.split(',')[0] if max_humidity < line.split(',')[7].to_i
        end
      end
    return max, max_date, min, min_date, max_humidity, max_humidity_date
  end

  def get_month_data(lines, index)
    lines.inject(0) { |sum, line| sum + line.split(',')[index].to_i unless line.split(',')[index].to_i.nil? }
  end

  def mode_a(filename, path)
    file = File.open("#{path}/#{filename}", 'r')
    lines = file.read.split("\n").select { |line| line.include? ',' }
    lines.delete_at(0)
    arr = []
    arr << get_month_data(lines, 1) / lines.size # max_temp
    arr << get_month_data(lines, 3) / lines.size # min_temp
    arr << get_month_data(lines, 7) / lines.size # avg_humidity
    file.close
    arr
  end

  def draw_lines(filename, path)
    file = File.open("#{path}/#{filename}", 'r')
    lines = file.read.split("\n").select { |line| line.include? ',' }
    lines.delete_at(0)
    lines.each do |line|
      min = line.split(',')[3].to_i
      max = line.split(',')[1].to_i
      day = "%02d" % Date.parse(line.split(',')[0]).day
      puts "#{day} #{('+' * min.abs).blue}#{('+'*max).red} #{min}C - #{max}C"

    end

  end
end
