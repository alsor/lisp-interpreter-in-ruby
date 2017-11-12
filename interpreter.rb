def lisp(source)
  tokens = tokenize(source)
  reader(tokens).each do |exp|
    eval(exp, {})
  end
end

class Token
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def number?
    name =~ /^\d/
  end

  def symbol?
    name =~ /^\D/
  end

  def inspect
    "\"#{name}\""
  end
end

OPEN_PARAM = '('
CLOSE_PARAM = ')'
LEXEMS = [OPEN_PARAM, CLOSE_PARAM]

def tokenize(source)
  tokens = []
  token = ''
  source.split("").each do |character|
    if character =~ /\s/ || character == ','
      next if token == ''
      tokens << Token.new(token)
      token = ''
    else
      if LEXEMS.include?(character)
        tokens << token unless token == ''
        tokens << character
        token = ''
      else
        token << character
      end
    end
  end

  tokens << Token.new(source) if tokens.empty?
  tokens
end

def reader(tokens)
  tree = []
  stack = []
  puts "tokens: #{tokens.inspect}"
  tokens.each do |token|
    if token == OPEN_PARAM
      list = []
      (stack.last || tree) << list
      stack.push(list)
    elsif token == CLOSE_PARAM
      stack.pop
    else
      (stack.last || tree) << token
    end
  end

  # ['do', tree].tap { |tree| puts "tree: #{tree.inspect}" }
  puts "tree: #{tree.inspect}"
  tree
end

def eval(exp, env)
  if exp.number?
    exp
  elsif exp.symbol?
    env.fetch(exp.name) { fail "Undefined variable #{exp.inspect}" }
  end
end

# lisp("(+ abc,   123 (abc a12 123.0))")
# lisp("(a b (c d (1 2 3) x) e f)")
# lisp("(a b)\n(c d)")
puts lisp('5').inspect
puts lisp('a').inspect
