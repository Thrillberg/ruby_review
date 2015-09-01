#Human [has hand]
#   - hit
#   - stay
# Dealer [has deck and hand]
#   - hit
#   - stay
#   - deal

#Deck

#Hand

#Game [has human and dealer]
#  - play
#  - welcome_message
#  - goodbye_message

class Dealer
  attr_accessor :hand

  def initialize
    @deck = Deck.new
    @hand = Hand.new
  end

  def deal(recipient)
    recipient.hand.cards << @deck.cards.shuffle.pop
  end

  def hit_or_stay
    if @hand.total >= 17
      'stay'
    end
  end

end

class Human
  attr_accessor :hand

  def initialize
    @hand = Hand.new
  end

  def hit_or_stay(dealer)
    puts "You have a total of #{hand.total}."
    puts "The dealer has a total of #{dealer.hand.total}"
    puts "Would you like to hit or stay?"

    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if answer == "hit" || answer == "stay"
      puts "Please enter 'hit' or 'stay'."
    end
    return answer
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def to_s
    phrase = ""
    cards.each { |card| phrase << "#{card[1]} of #{card[0]}, " }
    phrase[0..phrase.length - 3]
  end

  def card_to_i(card)
    if card[1].to_i != 0
      card[1].to_i
    elsif card[1] == 'Jack'
      10
    elsif card[1] == 'Queen'
      10
    elsif card[1] == 'King'
      10
    elsif card[1] == 'Ace'
      1
    end
  end

  def total
    array_of_cards = []
    cards.map { |card| array_of_cards << card_to_i(card) }
    output = array_of_cards.inject { |sum, card| sum + card }
    if array_of_cards.include?(1) && output < 10
      output += 10
    end
    output
  end
end

class Deck
  attr_accessor :cards

  def initialize
    suits = ['hearts', 'spades', 'diamonds', 'clubs']
    values = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
    @cards = suits.product(values)
  end

end

class Game
  attr_accessor :human, :dealer

  def initialize
    @human = Human.new
    @dealer = Dealer.new
  end

  def play
    welcome_message
    dealer.deal(human)
    dealer.deal(human)
    dealer.deal(dealer)
    dealer.deal(dealer)
    display_hands

    bust = 'false'

    loop do
      break if human.hit_or_stay(dealer) == 'stay'
      dealer.deal(human)
      display_hands
      if check_for_bust(human)
        puts "You have a total of #{human.hand.total}."
        puts "You bust! The computer wins."
        bust = 'true'
        break
      end
    end

    loop do
      break if dealer.hit_or_stay == 'stay'
      dealer.deal(dealer)
      puts "The dealer has hit."
      puts "The dealer has #{dealer.hand.cards.count} cards."
      if check_for_bust(dealer)
        puts "You have a total of #{human.hand.total} and the dealer has #{dealer.hand.total}."
        puts "The dealer bust! You win."
        bust = 'true'
        break
      end
    end

    if bust == 'false'
      if find_winner(human, dealer) == 'human'
        puts "Congratulations! You won with #{human.hand.total} points and the dealer had #{dealer.hand.total} points."
      elsif find_winner(human, dealer) == 'dealer'
        puts "Sorry, the dealer won with #{dealer.hand.total} points while you only had #{human.hand.total}."
      elsif find_winner(human, dealer) == 'tie'
        puts "It's a tie! You both have #{dealer.hand.total} points."
      end
    end

    display_hands
    goodbye_message
  end

  def display_hands
    puts "You have #{human.hand}."
    puts "The dealer has #{dealer.hand}."
  end

  def check_for_bust(player)
    if player.hand.total > 21
      'bust'
    end
  end

  def find_winner(human, dealer)
    'human' if human.hand.total > dealer.hand.total
    'dealer' if dealer.hand.total > human.hand.total
    'tie' if dealer.hand.total == human.hand.total
  end

  def welcome_message
    puts "Welcome to Twenty One!"
  end

  def goodbye_message
    puts "Thanks for playing!"
  end

end

Game.new.play
