class Say
  attr_accessor :number

  def initialize(number)
    @number = number
  end

  def in_english
    raise ArgumentError unless valid?(number)
    return "zero" if number.zero?
    chunks = []

    partition.each_with_index do |el, idx|
      chunks << Chunk.new(el, magnitude(idx))
    end

    chunks.reverse.reject{|ch| ch.number.zero? }.join(' ').strip

  end

  private

  def partition
    result = []
    number.to_s.chars.reverse.each_slice(3) do |a, b, c|
      result << [c, b, a].join.to_i.to_s
    end

    result
  end

  def magnitude(idx)
    case idx
    when 1
      'thousand'
    when 2
      'million'
    when 3
      'billion'
    when 4
      'trillion'
    end
  end

  def valid?(num)
    (0...1_000_000_000_000).include?(num)
  end
end

class Chunk
  attr_accessor :number, :magnitude

  def initialize(number, magnitude)
    @number = number.to_i
    @magnitude = magnitude
  end

  def to_s
    "#{in_english} #{magnitude}"
  end

  private

  def in_english
    return '' unless valid?(number)

    result = ''

    if number < 100
      num = number
      result = two_digits(num)
    else
      hundreds = number / 100
      result << "#{two_digits(hundreds)} hundred"
      two_digit_result = two_digits(number % 100)
      result << ' ' + two_digit_result unless two_digit_result == "zero"
    end

    result
  end

  def two_digits(num)
    result = nil

    if num < 10
      result = small_numbers[num % 10]
    elsif num < 20
      result = small_numbers[num]
    else num < 100
      ones_number = num % 10
      tens_number = num / 10

      result = tens[tens_number]
      result << "-#{ones[ones_number]}" unless ones_number.zero?
    end

    result
  end

  def small_numbers
    ones + %w(ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen)
  end

  def ones
    %w(zero one two three four five six seven eight nine)
  end

  def tens
    [nil] + %w(ten twenty thirty forty fifty sixty seventy eighty ninety)
  end

  def valid?(num)
    (0..999).include?(num)
  end
end
