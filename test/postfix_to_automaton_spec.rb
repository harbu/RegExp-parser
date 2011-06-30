# encoding: utf-8

require 'automaton_runner'
require 'postfix_to_automaton'

describe PostfixToAutomaton do
  describe "with a simple expression" do
    it "should build a correct NFA when the expression is a single symbol" do
      converter = PostfixToAutomaton.new "a"
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      runner.run("").should be_false
      runner.run("b").should be_false
      runner.run("a").should be_true
    end
    
    it "should build a correct NFA when the expression is a repetition" do
      converter = PostfixToAutomaton.new "a*"
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      runner.run("c").should be_false
      3.times {|num| runner.run("a" * num).should be_true }
    end
    
    it "should a correct NFA when the expression is a single catenation" do
      converter = PostfixToAutomaton.new "ab."
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      runner.run("a").should be_false
      runner.run("abb").should be_false
      runner.run("ab").should be_true
    end
    
    it "should a correct NFA when the expression is a single alternation" do
      converter = PostfixToAutomaton.new "ab|"
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      runner.run("").should be_false
      runner.run("c").should be_false
      runner.run("ab").should be_false
      runner.run("a").should be_true
      runner.run("b").should be_true
    end    
  end
  
  describe "with a compound expression" do
    it "should build correct NFA when the expression contains three different operations" do
      converter = PostfixToAutomaton.new "ab.c*|"
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      3.times {|num| runner.run("c" * num).should be_true }
      runner.run("ab").should be_true
    end
    
    it "should build correct NFA for very complex expression" do
      converter = PostfixToAutomaton.new "ab.cd|*.fg.h.i."
      runner = Automaton::AutomatonRunner.new(converter.automaton)
      runner.run("abcfghi").should be_true
    end
  end
end
