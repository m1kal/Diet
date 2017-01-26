class Day
  attr_reader :date

  def self.from_json(input)
    data = JSON.parse(input, :symbolize_names => true)
    new(data[:date], data[:meals], data[:excercises])
  end

  def initialize(date = nil, meals = [], excercises = [])
    @meals = meals
    @excercises = excercises
    @date = date || Time.now.to_s[0, 10]
  end

  def add_meal(meal)
    @meals << meal
    self
  end

  def add_excercise(excercise)
    @excercises << excercise
    self
  end

  def meals
    @meals.dup
  end

  def excercises
    @excercises.dup
  end

  def calories
    calculate_calories(@meals)
  end

  def calories_burnt
    calculate_calories(@excercises)
  end

  def calculate_calories(table)
    table.reduce(0) { |acc, elem| acc + elem[:calories] } || 0
  end

  def total_calories
    calories - calories_burnt
  end

  def to_json(_options = nil)
    '{"meals":' + @meals.to_json +
      ', "excercises":' + @excercises.to_json +
      ', "date":' + @date.to_json + '}'
  end

  def clear
    @meals = []
    @excercises = []
  end

  def show_items(items)
    puts 'showing' + items.to_s
    send(items).collect do |elem|
      puts elem[:name] + elem[:calories].to_s
      yield(elem[:name], elem[:calories])
    end.join('')
  end

  def merge(other)
    other.meals.each { |meal| add_meal(meal) }
  end

  private :calculate_calories
end
