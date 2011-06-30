# encoding: utf-8
# Converts given infix regular expression to postfix form so that it can easily
# be interpreted by a computer. Implementing using the Shunting-yard algorithm.

class InfixToPostfix
  
  Precedence = { '(' => 0, '*' => 3, '.' => 2, '|' => 1 }
  
  def self.convert(infix)
    postfix = ""
    stack = []
    infix.each_char do |char|
      if char =~ /[\.\*\|]/
        until stack.empty? || Precedence[char] > Precedence[stack.last]
          postfix += stack.pop
        end
        stack.push(char)
      elsif char == ')'
        until stack.last == '('
          raise "mismatched paranthesis" if stack.empty? 
          postfix += stack.pop
        end
        stack.pop
      elsif char == '('
        stack.push(char)
      else
        postfix += char
      end
    end
      until stack.empty?
        raise "mismatched paranthesis" if stack.last =~ /[\)\(]/
        postfix += stack.pop
      end
    postfix
  end
end
