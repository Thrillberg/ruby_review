class Say
  attr_reader :numeral

  def initialize(numeral)
    @numeral = numeral
  end

  def say(numeral)
    split_numeral = numeral.to_s.chars

    ones_place_hash = {"0" => "zero", "1" => "one", "2" => "two",
                    "3" => "three", "4" => "four", "5" => "five", 
                    "6" => "six", "7" => "seven", "8" => "eight", 
                    "9" => "nine"}

    tens_place_hash = {"0" => "", "2" => "twenty", "3" => "thirty",
                      "4" => "forty", "5" => "fifty",
                      "6" => "sixty", "7" => "seventy",
                      "8" => "eighty", "9" => "ninety"}

    teens_hash = {"11" => "eleven", "12" => "twelve",
                  "13" => "thirteen", "14" => "fourteen",
                  "15" => "fifteen", "16" => "sixteen",
                  "17" => "seventeen", "18" => "eighteen",
                  "19" => "ninteen"}

    if split_numeral.size == 1
      number = ones_place_hash[split_numeral[0]]

    elsif split_numeral.size == 2 && split_numeral[0] == "1"
      number = teens_hash[split_numeral[0] << split_numeral[1]]

    elsif split_numeral.size == 2 && split_numeral[1] == "0"
      number = tens_place_hash[split_numeral[0]]

    elsif split_numeral.size == 2 && split_numeral[0] != "-"
      tens_place = tens_place_hash[split_numeral[0]]
      ones_place = ones_place_hash[split_numeral[1]]
      number = tens_place + " " + ones_place

    elsif split_numeral.size == 3
      hundreds_place = ones_place_hash[split_numeral[0]]
      tens_place = tens_place_hash[split_numeral[1]]
      if ones_place_hash[split_numeral[2]] == "zero"
        ones_place = ""
      else
        ones_place = ones_place_hash[split_numeral[2]]
      end
      number = hundreds_place + " hundred " + tens_place + " " + ones_place

    elsif split_numeral.size > 3
      more_than_three_digits(split_numeral)

    else 
      puts "Complaint!"
    end

    number
  end

  def more_than_three_digits(chunks)
    chunks = chunks(numeral)
    chunks.split(' ').each do |chunk|
      puts say(chunk)
    end
  end

  def chunks(numeral)
    result = {}
    big_number_array = []
    numeral.to_s.chars.reverse.each_slice(3) do |a, b, c|
      big_number_array << [c, b, a].join.to_i.to_s
    end

    big_number_places = %w(hundred thousand million billion)

    result = Hash[big_number_places.zip(big_number_array.map {|i| i})]

    if result["billion"]
      billions = "#{result["billion"]}" + " " + "billion "
    end

    if result["million"]
      millions = "#{result["million"]}" + " " + "million "
    end

    if result["thousand"]
      thousands = "#{result["thousand"]}" + " " + "thousand "
    end

    if result["hundred"].to_i > 0
      hundreds = "#{result["hundred"]}"
    end

    result = "#{billions}" + "#{millions}" + "#{thousands}" + "#{hundreds}"
  end
end

say1 = Say.new(1234567890).say(1234567890)
