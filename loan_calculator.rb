def invalid_input_check(input)
  return if /\d/.match(input)
  puts "Your input was invalid!"
  abort
end

puts "Welcome to your loan calculator! For this we'll need three pieces of information: the total loan amount, the Annual Percentage Rate (APR), and the loan duration in years."
puts "What is the total loan amount?"
total = gets.chomp
invalid_input_check(total)
total = total.to_f

puts "What is the APR? (For example, if it is quoted as 6%, please enter 6)"
apr = gets.chomp
invalid_input_check(apr)
apr = apr.to_f

puts "What is the duration in years?"
years = gets.chomp
invalid_input_check(years)
years = years.to_f

monthly_interest_rate = (apr / 100) / 12
months = years * 12

exponential_part = (1 + monthly_interest_rate)**months
a = total * monthly_interest_rate * exponential_part
b = exponential_part - 1

monthly_payment = a / b

monthly_payment = (monthly_payment).round(2)

puts "Your monthly payment is " + monthly_payment.to_s + "."
