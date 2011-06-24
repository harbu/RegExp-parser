# encoding: utf-8
# Takes an expression and attempts to build a parse tree from it.

class ExpressionParser
  STAR_OPERATOR = "*"
  INTERSECTION_OPERATOR = "&"
  UNION_OPERATOR = "|"
  
  DISALLOWED_SYMBOLS = [STAR_OPERATOR, INTERSECTION_OPERATOR, UNION_OPERATOR,
      "(", ")"]
  
  attr_reader :value, :left, :right
  
  def initialize(expression)
    if expression.length == 1
      if DISALLOWED_SYMBOLS.include?(expression)
        raise "one character expression can't be an operator"
      end
      @value = expression
    else
      if expression[0] != "(" || expression[-1] != ")"
        raise "missing paranthesis at beginning or end"
      end
      @value = expression[2]
      @left = ExpressionParser.new(expression[1])
      @right = ExpressionParser.new(expression[3]) if expression[3] != ")"
    end
  end
end

