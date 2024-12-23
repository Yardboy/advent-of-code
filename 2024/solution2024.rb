class Solution2024
  def initialize
    @test = false
    @input = []
    @input_lines = 0
    @answer = nil
  end

  def run!(testmode: true)
    @test = testmode
    read_input
    additional_setup
    process_input
    show_answer
  end

  private

  def additional_setup; end

  def process_input; end

  def show_answer
    puts "Input Lines: #{@input_lines}"
    puts "The answer is: #{@answer}"
  end

  def read_input
    if @test
      file_to_input 'input-test.txt'
    else
      file_to_input 'input.txt'
    end
  end

  def split_input(delimiter: ' ')
    @input = @input.map { |line| line.split(delimiter) }
  end

  def inputs_are_integers
    @input = @input.map { |line| line.map(&:to_i) }
  end

  def file_to_input(file)
    File.open(file, 'r') do |f|
      f.each_line do |line|
        @input << line.chomp
        @input_lines += 1
      end
    end
  end
end
