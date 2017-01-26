require_relative 'diet'

class DietUI
  def main_loop
    @diet = Diet.new
    @day = nil
    loop do
      puts 'Command: (? for help)'
      cmd = gets.chomp.downcase
      return if cmd == 'q'
      parse(cmd)
    end
  end

  def parse(cmd)
    case (cmd.split(' ').first)
    when 'new_diet' then @diet = Diet.new
    when 'show' then show_diet
    when 'total' then puts @diet.calories
    when 'new_day' then @diet.add_day(Day.new(cmd.split(' ')[1]))
    when 'add_meal' then add_meal(cmd.split(' '))
    when '?' then puts 'new_diet, show, total, new_day, add_meal, q'
    end
  end

  def add_meal(cmd)
    if cmd.size == 3
      meal = { :name => cmd[1], :calories => cmd[2].to_i }
    else
      puts 'Give the name and calories'
      input = gets.chomp.split(' ')
      meal = { :name => input[0], :calories => input[1].to_i }
    end
    @diet.add_meal(meal)
  end

  def show_diet
    puts @diet.to_json
  end
end

DietUI.new.main_loop
