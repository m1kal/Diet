# Day
class Day
  attr_reader :date

  def self.from_json(input)
    data = JSON.parse(input, symbolize_names: true)
    new(data[:date], data[:meals], data[:exercises])
  end

  def initialize(date = nil, meals = [], exercises = [])
    @meals = meals
    @exercises = exercises
    @date = date || Time.now.to_s[0, 10]
  end

  def add_meal(meal)
    @meals << meal
    self
  end

  def add_exercise(exercise)
    @exercises << exercise
    self
  end

  def meals
    @meals.dup
  end

  def exercises
    @exercises.dup
  end

  def calories
    calculate_calories(@meals)
  end

  def calories_burnt
    calculate_calories(@exercises)
  end

  def calculate_calories(table)
    table.reduce(0) { |acc, elem| acc + elem[:calories] } || 0
  end

  def total_calories
    calories - calories_burnt
  end

  def to_json(_options = nil)
    '{"meals":' + @meals.to_json +
      ', "exercises":' + @exercises.to_json +
      ', "date":' + @date.to_json + '}'
  end

  def clear
    @meals = []
    @exercises = []
  end

  def show_items(items)
    send(items).collect do |elem|
      yield(elem[:name], elem[:calories])
    end.join('')
  end

  def merge(other)
    other.meals.each { |meal| add_meal(meal) }
  end

  private :calculate_calories
end
