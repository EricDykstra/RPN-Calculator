class RPNCalc

  ASCII_DIGIT_START = 48
  OPERATORS = [:+, :-, :*, :/]

  def initialize input
    @stack = []
    @args = input.split(" ")
  end

  def self.run input
    new(input).run
  end

  def run
    until @args.empty?
      @stack << @args.shift
      if operator?(:"#{@stack.last}")
        raise "not enough arguments" if @stack.length < 3
        perform_operation
      end
    end
    @stack.first
  end

  def perform_operation
    if OPERATORS.include? :"#{@stack.last}"
      num1, num2, operator = @stack.pop(3)
      num1 = convert_to_num(num1)
      num2 = convert_to_num(num2)
      @stack.push num1.send(operator, num2)
    else
      send :"#{@stack.last}"
    end
  end

  def convert_to_num arg
    return arg if arg.is_a? Fixnum
    raise "invalid number" if arg.split(".").count > 2
    is_negative = arg[0] == "-" ? true : false
    if is_negative
      arg = arg[1..-1]
    end
    return_number = arg.include?(".") ? atof(arg) : atoi(arg)
    if is_negative
      -return_number
    else
      return_number
    end
  end

  def atoi arg
    arg.each_byte.map.with_index do |b,i|
      raise "invalid number" if b < ASCII_DIGIT_START || b > ASCII_DIGIT_START + 10
      (b - ASCII_DIGIT_START) * (10**(arg.length - (i+1)))
    end.inject(:+)
  end

  def atof arg
    pre, post = arg.split('.')
    post_length = post.length
    pre = atoi pre
    post = atoi(post) / (10.0 ** post_length )
    pre + post
  end

  def custom_operator custom_operator, num1, num2
    send custom_operator, num1, num2
  end

  def doubleminus
    num1, num2, operator = @stack.pop(3)
    num1 = convert_to_num(num1)
    num2 = convert_to_num(num2)
    @stack.push (num1 - num2 - num2)
  end

  def sum
    @stack = [ @stack[0..-2].map{|n| convert_to_num n}.inject(:+) ]
  end

  def operator? sym
    OPERATORS.include?(sym) || self.methods.include?(sym)
  end

end
