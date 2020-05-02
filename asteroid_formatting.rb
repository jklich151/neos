class AsteroidFormatting

  COLUMN_LABELS = { name: "Name", diameter: "Diameter", miss_distance: "Missed The Earth By:" }

  def initialize(date, details)
    @date = date
    @asteroid_details = details
  end

  def display_results
    puts "______________________________________________________________________________"
    puts "On #{formated_date}, there were #{total_number_of_asteroids} objects that almost collided with the earth."
    puts "The largest of these was #{largest_asteroid_diameter} ft. in diameter."
    puts "\nHere is a list of objects with details:"
    puts divider
    puts header
    create_rows(column_data)
    puts divider
  end

  def formated_date
    DateTime.parse(@date).strftime("%A %b %d, %Y")
  end

  def total_number_of_asteroids
    @asteroid_details[:total_number_of_asteroids]
  end

  def largest_asteroid_diameter
    @asteroid_details[:biggest_asteroid]
  end

  def divider
    "+-#{column_data.map { |_,col| "-"*col[:width] }.join('-+-') }-+"
  end

  def header
    "| #{ column_data.map { |_,col| col[:label].ljust(col[:width]) }.join(' | ') } |"
  end

  def format_row_data(row_data, column_info)
    row = row_data.keys.map { |key| row_data[key].ljust(column_info[key][:width]) }.join(' | ')
    puts "| #{row} |"
  end

  def create_rows(column_info)
    asteroid_list.each { |asteroid| format_row_data(asteroid, column_info) }
  end

  def column_data
    COLUMN_LABELS.each_with_object({}) do |(col, label), hash|
      hash[col] = {
        label: label,
        width: [asteroid_list.map { |asteroid| asteroid[col].size }.max, label.size].max}
    end
  end

  def asteroid_list
    @asteroid_details[:asteroid_list]
  end
end
