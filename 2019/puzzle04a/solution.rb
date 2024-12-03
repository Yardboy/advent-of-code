#!/usr/local/bin/ruby
require '../solution2019'

class Solution < Solution2019
  private

  # override
  def additional_setup
    @answer = []
  end

  def process_input
    @input.each do |password|
      @answer << password if valid?(password.to_s)
    end
    @answer = @answer.size
  end

  def valid?(password)
    password_has_double?(password) && password_never_decreases?(password)
  end

  def password_has_double?(password)
    (1..5).any? { |i| password[i] == password[i - 1] }
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
