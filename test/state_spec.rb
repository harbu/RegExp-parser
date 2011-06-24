# encoding: utf-8

require 'nondeterministic_automaton'
require 'set'
require 'state'

describe Automaton::State do
  before(:each) do
    @automaton = Automaton::NondeterministicAutomaton.new ['a', 'b']
    @state = Automaton::State.new(@automaton)
  end
  
  describe "on instantiation" do
    it "should have no transitions defined" do
      @state.transitions('a').should be_empty
      @state.transitions('b').should be_empty
      @state.transitions(:epsilon).should be_empty
    end
  end

  describe "when adding transitions" do
    it "should not allow adding symbols that don't belong to its alphabet" do
      lambda { @state.add_transition('c', @state) }.should raise_error RuntimeError, "Symbol not in state's alphabet"
    end
    
    it "should not allow linking to a state using a different automaton" do
      automaton_two = Automaton::NondeterministicAutomaton.new ['a', 'b']
      state_two = Automaton::State.new(automaton_two)
      lambda { @state.add_transition('a', state_two) }.should raise_error RuntimeError, "States have different automata"
    end
    
    it "should successfully add transitions on valid arguments" do
      state_two = Automaton::State.new(@automaton)
      @state.add_transition('b', state_two)
      @state.add_transition('b', @state)
      @state.transitions('b').should == Set.new([@state, state_two])
    end
    
    it "should successfully add transition for epsilon symbol" do
      @state.add_transition(:epsilon, @state)
      @state.transitions(:epsilon).should == Set.new([@state])
    end
  end
end


