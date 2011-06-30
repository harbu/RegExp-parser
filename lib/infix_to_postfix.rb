# encoding: utf-8
# Converts given infix regular expression to postfix form so that it can easily
# be interpreted by a computer. Implemented with the Shunting-yard algorithm.

class InfixToPostfix
  
  Precedence = { '*' => 3, '.' => 2, '|' => 1, '(' => 0, }
  
  def self.convert(infix)
    @postfix = ""
    @stack = []
    infix.each_char do |char|
      if operator?(char)
        pop_lower_precedence(char)
        @stack.push(char)
      elsif char == ')'
        pop_till_paranthesis_matched
      elsif char == '('
        @stack.push(char)
      else
        @postfix += char
      end
    end
    pop_till_empty
    @postfix
  end
  
private
  def self.operator?(char)
    char =~ /[\.\*\|]/
  end
  
  def self.paranthesis?(char)
    char =~ /[\)\(]/
  end
  
  def self.pop_lower_precedence(char)
    until @stack.empty? || Precedence[char] > Precedence[@stack.last]
      @postfix += @stack.pop
    end
  end
  
  def self.pop_till_paranthesis_matched
    until @stack.last == '('
      raise "mismatched paranthesis" if @stack.empty? 
      @postfix += @stack.pop
    end
    @stack.pop
  end
  
  def self.pop_till_empty
    until @stack.empty?
      raise "mismatched paranthesis" if paranthesis?(@stack.last)
      @postfix += @stack.pop
    end
  end
end
