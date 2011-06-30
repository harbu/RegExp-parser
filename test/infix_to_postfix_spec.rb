# encoding: utf-8

require 'infix_to_postfix'

describe InfixToPostfix do
  describe "when expression is not well formed" do
    it "should fail if expression contains mismatched paranthesis" do
      lambda { InfixToPostfix.convert("(") }.should raise_error "mismatched paranthesis"
      lambda { InfixToPostfix.convert(")") }.should raise_error "mismatched paranthesis"
      lambda { InfixToPostfix.convert("((a.d)|b*))") }.should raise_error "mismatched paranthesis"
    end
  end
  
  describe "when expression is well-formed" do
    it "should return the postfix equivalent of a single-symbol infix expression" do
      InfixToPostfix.convert("a").should == "a"
    end
    
    it "should return the postfix equivalent of a repetition infix expression" do
      InfixToPostfix.convert("a*").should == "a*"
    end
    
    it "should return the postfix equivalent of an alternation infix expression" do
      InfixToPostfix.convert("a|b").should == "ab|"
    end
    
    it "should return the postfix equivalent of a catenation infix expression" do
      InfixToPostfix.convert("a.b").should == "ab."
    end
    
    it "should return the postfix equivalent of a compound, complex expression" do
      InfixToPostfix.convert("((((a.b)|(c.d))*).(e|f))").should == "ab.cd.|*ef|."
    end
  end
end
