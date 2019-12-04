#!/usr/local/bin/ruby
require '../solution2019'

class Solution < Solution2019
  private

  def process_input
    @answer = []
    @input.each do |password|
      @answer << password if valid?(password.to_s)
    end
    @answer = @answer.size
  end

  def valid?(password)
    password_has_double?(password) && password_never_decreases?(password)
  end

  # slow :(
  def password_has_double?(password)
    password.scan(/\w/).chunk { |i| i }.any? { |_, ary| ary.size == 2 }
  end

  def letter_counts(password)
    password.split('').each_with_object({}) do |letter, hsh|
      hsh[letter] ||= 0
      hsh[letter] += 1
    end
  end

  def password_never_decreases?(password)
    (1..5).all? { |i| password[i] >= password[i - 1] }
  end

  # override
  def read_input
    @input = (372_304..847_060)
  end
end

Solution.new.run! # true
