# encoding: utf-8

require 'nondeterministic_automaton'
require 'state'

describe Automaton::NondeterministicAutomaton do
  before(:each) do
    @automaton = Automaton::NondeterministicAutomaton.new
  end
  
  describe "on instantiation" do
    it "should have by default the English alphabet as its alphabet" do
      @automaton.alphabet.should == Set.new('a'..'z')
    end
    
    it "should have a custom alphabet if given explicitly on initialization" do
      automaton = Automaton::NondeterministicAutomaton.new(['a', 'b'])
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
  
  describe "when adding state" do
    before(:each) do
      @state = @automaton.add_state
    end
    
    it "should find new state in the automaton's state list" do
      @automaton.states.should include(@state)
    end
    
    it "should create one that inherits its alphabet from the automaton" do
      @state.compatible_state?(Automaton::State.new('a'..'z')).should be_true
    end
    
    it "should create a reject state by default" do
      @automaton.accept_state?(@state).should be_false
    end
  end
  
  describe "contains a start state that" do
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
      outside_state = Automaton::State.new ['a', 'b']
      lambda { @automaton.start_state = outside_state }.should raise_error RuntimeError, "state not present in automaton"
    end 
  end
  
  describe "when marking accept states" do
    it "should not allow states that are not present in automaton" do
      outside_state = Automaton::State.new ['a', 'b']
      lambda { @automaton.mark_accept_state(outside_state)}.should raise_error RuntimeError, "state not present in automaton"
    end
    it "should work correctly on states present in automaton" do
      state = @automaton.add_state
      @automaton.mark_accept_state(state)
      @automaton.accept_state?(state).should be_true
    end
  end
end
