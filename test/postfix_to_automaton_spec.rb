# encoding: utf-8

require 'postfix_to_automaton'

describe PostfixToAutomaton do
  describe "with a simple expression" do
    it "should build a NFA correctly when the expression is a single symbol" do
      converter = PostfixToAutomaton.new "a"
      automaton = converter.automaton
      start_state = automaton.start_state
      accept_state = start_state.transitions('a').first
      
      automaton.states.size.should == 2
      automaton.accept_state?(start_state).should be_false
      automaton.accept_state?(accept_state).should be_true
    end
    
    it "should build a NFA correctly when the expression is a repetition" do
      converter = PostfixToAutomaton.new "a*"
      automaton = converter.automaton
      start_state = automaton.start_state
      repeat_state = start_state.transitions('a').first
      accept_state = start_state.transitions(:epsilon).first
      
      automaton.states.size.should == 3
      automaton.accept_state?(start_state).should be_false
      automaton.accept_state?(repeat_state).should be_false
      automaton.accept_state?(accept_state).should be_true
      repeat_state.transitions(:epsilon).first.should == start_state
    end
      
    it "should build a NFA correctly when the expression is a single catenation" do
      converter = PostfixToAutomaton.new "ab."
      automaton = converter.automaton
      start_state = automaton.start_state
      second_state = start_state.transitions('a').first
      last_state = second_state.transitions('b').first
      
      automaton.states.size.should == 3
      automaton.accept_state?(start_state).should be_false
      automaton.accept_state?(second_state).should be_false
      automaton.accept_state?(last_state).should be_true
    end
    
    it "should build a NFA correctly when the expression is a single alternation" do
      converter = PostfixToAutomaton.new "ab|"
      automaton = converter.automaton
      start_state = automaton.start_state
      middle_states = automaton.start_state.transitions(:epsilon).to_a
      if middle_states[0].transitions('a').empty?
        last_state_one = middle_states[0].transitions('b').first
        last_state_two = middle_states[1].transitions('a').first
      else
        last_state_one = middle_states[0].transitions('a').first
        last_state_two = middle_states[1].transitions('b').first
      end
      
      automaton.states.size.should == 4
      automaton.accept_state?(start_state).should be_false
      automaton.accept_state?(middle_states[0]).should be_false
      automaton.accept_state?(middle_states[1]).should be_false
      automaton.accept_state?(last_state_one).should be_true
      last_state_one.should == last_state_two
    end 
  end
  
  describe "with a compound expression" do
    it "should build a NFA correctly when the expression is three joined catenation operations" do
      converter = PostfixToAutomaton.new "abc.."
    end
  end
end
