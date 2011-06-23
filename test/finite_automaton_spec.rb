# encoding: utf-8
require 'finite_automaton'
require 'state'

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
      state.compatible_state?(State.new('a'..'z')).should
    end
  end
  
  describe "start state" do
    before(:each) do
      @first_state = @automaton.add_state
    end
    
    it "should be automatically set when first state added" do
      @automaton.start_state.should == @first_state
    end
    
    it "should not be automatically re-set after first state has already been added" do
      @automaton.add_state
      @automaton.start_state.should == @first_state
    end
      
    
    it "should be changeable to any state present in the automaton" do
      states = 3.times.collect { @automaton.add_state }
      @automaton.start_state = states.last
      @automaton.start_state.should == states.last
    end
    
    it "should not be changeable to a state that isn't present in the automaton" do
      outside_state = State.new ['a', 'b']
      lambda { @automaton.start_state = outside_state }.should raise_error RuntimeError, "state not present in automaton"
    end 
  end
end
