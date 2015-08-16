SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total(cards) > 21
end

def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > 21
    :player_busted
  elsif dealer_total > 21
    :dealer_busted
  elsif dealer_total < player_total
    :player_cards
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    puts "You busted! Dealer wins!"
  when :dealer_busted
    puts "Dealer busted! You win!"
  when :player
    puts "You win!"
  when :dealer
    puts "Dealer wins!"
  when :tie
    puts "It's a tie!"
  end
end

def play_again?
  puts "----------"
  puts "Play again? (y/n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  puts "Welcome to Twenty One! Enjoy the game."

  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  puts "Dealer has #{dealer_cards[0]} and ?"
  puts "You have: #{player_cards[0]} and #{player_cards[1]}, for a total of #{total(player_cards)}."

  loop do
    player_turn = nil
    loop do
      puts '(h)it or (s)tay?'
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      puts "Sorry, you must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      puts "You chose to hit."
      puts "Your cards are now: #{player_cards}"
      puts "Your total is now: #{total(player_cards)}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts "You stayed at #{total(player_cards)}"
  end

  puts "Dealer turn..."

  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= 17
    puts "Dealer hits."
    dealer_cards << deck.pop
    puts "Dealer's cards are now: #{dealer_cards}"
  end

  dealer_total = total(dealer_cards)
  if busted?(dealer_cards)
    puts "Dealer's total is now: #{dealer_total}"
    display_result(dealer_cards, player_cards)
    play_again? ? next : break
  else
    puts "Dealer stays at #{dealer_total}"
  end

  puts "=============="
  puts "Dealer has #{dealer_cards}, for a total of: #{total(dealer_cards)}"
  puts "Player has #{player_cards}, for a total of: #{total(player_cards)}"
  puts "=============="

  display_result(dealer_cards, player_cards)

  break unless play_again?
end

puts "Thank you for playing Twenty One! Good bye!"
