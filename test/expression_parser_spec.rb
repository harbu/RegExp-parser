# encoding: utf-8

require 'expression_parser'

describe ExpressionParser do
  describe "with a one character expression" do
    it "should fail if the character is an operation" do
      lambda { ExpressionParser.new "*" }.should raise_error
      lambda { ExpressionParser.new "&" }.should raise_error
      lambda { ExpressionParser.new "|" }.should raise_error
    end
    
    it "should fail if the character is a paranthesis" do
      lambda { ExpressionParser.new "(" }.should raise_error
      lambda { ExpressionParser.new ")" }.should raise_error
    end
    
    it "should succeed if the character is anything else" do
      root_one = ExpressionParser.new "a"
      root_two = ExpressionParser.new "."
      root_one.value.should == "a"
      root_two.value.should == "."
    end
  end
  
  describe "with a unary (star) expression" do
    it "should fail if expression not surrounded by paranthesis" do
      lambda { ExpressionParser.new "a*" }.should raise_error
    end
    
    it "should fail if operand is an unallowed character (symbol or paranthesis)" do
      lambda { ExpressionParser.new "(*" }.should raise_error
    end
    
    it "should succeed by building a tree with a root node with one child" do
      root = ExpressionParser.new "(a*)" 
      root.value.should == "*"
      root.left.value.should == "a"
    end
  end
  
  describe "with a binary expression" do
    it "should fail if expression not surrounded by paranthesis" do
      lambda { ExpressionParser.new "a&b" }.should raise_error
    end
    
    it "should fail if either operand is an unallowed character (symbol or paranthesis)" do
      lambda { ExpressionParser.new "(&a" }.should raise_error
      lambda { ExpressionParser.new "b|*" }.should raise_error
    end
    
    it "should succeed by building a tree with a root node with two children" do
      root = ExpressionParser.new "(a|b)"
      root.value.should == "|"
      root.left.value.should == "a"
      root.right.value.should == "b"
    end
  end
end
