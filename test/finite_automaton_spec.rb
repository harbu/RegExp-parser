# encoding: utf-8
require 'finite_automaton'

describe FiniteAutomaton do
  before(:each) do
    @automaton = FiniteAutomaton.new
  end
  
  describe "on instantiation" do
    it "should have by default the English alphabet as its alphabet" do
      @automaton.alphabet.should == Set.new('a'..'z')
    end
    
    it "should have a custom alphabet if given explicitly on initialization" do
      automaton = FiniteAutomaton.new(['a', 'b'])
      automaton.alphabet.should == Set.new(['a', 'b'])
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
  
  describe "on adding state" do
    it "should be found in the automaton's state list" do
      state = @automaton.add_state
      @automaton.states.should include(state)
    end
    
    it "should create one that inherits its alphabet from the automaton" do
      state = @automaton.add_state
      state.incompatible_state?(State.new('a'..'z')).should_not
    end
  end
end
