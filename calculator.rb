puts 'What is the first number?'
num1 = gets.chomp
puts 'What is the second number?'
num2 = gets.chomp
if !/\d/.match(num1) || !/\d/.match(num2)
  puts 'One of your numbers is invalid'
  abort
end

puts 'What operation would you like to do on them? (+, -, *, or /)'
operator = gets.chomp
if operator == '+'
  puts num1.to_f + num2.to_f
elsif operator == '-'
  puts num1.to_f - num2.to_f
elsif operator == '*'
  puts num1.to_f * num2.to_f
elsif operator == '/'
  puts num1.to_f / num2.to_f
else
  puts 'Sorry that is invalid.'
  abort
end
