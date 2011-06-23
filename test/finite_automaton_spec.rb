# encoding: utf-8
require 'finite_automaton'

describe FiniteAutomaton, "on instantiation" do
  before(:each) do
    @automaton = FiniteAutomaton.new
  end
  
  it "should have by default the English alphabet as its alphabet" do
    @automaton.alphabet.should == ('a'..'z')
  end
  
  it "should have a custom alphabet if given explicitly on initialization" do
    automaton = FiniteAutomaton.new(['a', 'b'])
    automaton.alphabet.should == ['a', 'b']
  end
  
  it "should have an empty set of states" do
    @automaton.states.should be_empty
  end
  
  it "should have a nil start state" do
    @automaton.start_state.should be_nil
  end
  
  it "should have an empty set of accept states" do
    @automaton.accept_states.should be_empty
  end
end
