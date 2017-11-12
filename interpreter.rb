def scheme(source)
  reader(source)
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
      tokens << token
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
  tokens
end

def reader(source)
  tree = []
  stack = []
  tokens = tokenize(source)
  puts "tokens: #{tokens.inspect}"
  tokens.each do |token|
    if token == OPEN_PARAM
      list = []
      (stack.last || tree) << list
      stack.push(list)
    elsif token == CLOSE_PARAM
      stack.pop
    else
      stack.last << token
    end
  end
  puts "tree: #{tree.inspect}"
  tree
end

# reader("(+ abc,   123 (abc a12 123.0))")
# reader("(a b (c d (1 2 3) x) e f)")
reader("(a b)\n(c d)")
