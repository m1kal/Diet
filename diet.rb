require 'json'
require_relative 'day'

class Diet
  attr_reader :current_day

  def self.from_storage(serializer, options)
    from_json(serializer.load(options))
  end

  def self.from_json(json)
    data = JSON.parse(json, :symbolize_names => true)
    data[:days].reduce(new) do |acc, day|
      acc.add_day(Day.from_json(day.to_json))
    end
  end

  def to_storage(serializer, options)
    serializer.save(to_json, options)
  end

  def to_json
    '{"days":' + @days.to_json + '}'
  end

  def initialize
    @days = []
  end

  def add_day(day)
    @days << day
    @current_day = day
    self
  end

  def merge_duplicate_days
    dates = @days.collect(&:date).uniq
    days_new = []
    dates.each do |date|
      days_with_given_date = @days.select { |day| day.date == date }
      days_new << Day.new(date)
      days_with_given_date.each { |day| days_new[-1].merge(day) }
    end
    @days = days_new
    self
  end

  def calories
    @days.map(&:calories).reduce(&:+) || 0
  end

  def day(date)
    return @days[-1] if date == :last
    @days.select { |day| day.date == date }.first ||
      add_day(Day.new(date)).day(date)
  end

  def select_day(date)
    @current_day = day(date)
  end

  def add_meal(input)
    @current_day ||= day(:last)
    add_day(Day.new) if @current_day.nil?
    @current_day.add_meal(input)
    self
  end

  def add_exercise(input)
    @current_day ||= day(:last)
    add_day(Day.new) if @current_day.nil?
    @current_day.add_exercise(input)
    self
  end

  def clear_day(date = nil)
    day = (date.nil? ? @current_day || day(:last) : day(date))
    day.clear
    self
  end

  def each(&block)
    @days.sort_by(&:date).each(&block)
  end
end
