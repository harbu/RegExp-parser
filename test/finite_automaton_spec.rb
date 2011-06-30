# encoding: utf-8

require 'finite_automaton'
require 'state'

describe Automaton::FiniteAutomaton do
  before(:each) do
    @automaton = Automaton::FiniteAutomaton.new
  end
  
  describe "on instantiation" do
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
      outside_state = Automaton::State.new(@automaton)
      lambda { @automaton.start_state = outside_state }.should raise_error RuntimeError, "state not present in automaton"
    end 
  end
  
  describe "when marking accept states" do
    it "should not allow states that are not present in automaton" do
      outside_state = Automaton::State.new(@automaton)
      lambda { @automaton.mark_accept_state(outside_state)}.should raise_error RuntimeError, "state not present in automaton"
    end
    it "should work correctly on states present in automaton" do
      state = @automaton.add_state
      @automaton.mark_accept_state(state)
      @automaton.accept_state?(state).should be_true
    end
  end
  
  describe "when importing states from another automaton" do
    before(:each) do
      @automaton = Automaton::FiniteAutomaton.new
      states = 2.times.collect { @automaton.add_state }
      states.first.add_transition('a', states.last)
      @automaton.mark_accept_state(states.last)
      
      @original_start_state = states.first
      @original_accept_states = Array.new(@automaton.accept_states)
      
      @other = Automaton::FiniteAutomaton.new
      states = 4.times.collect { @other.add_state }
      states[0].add_transition('a', states[1])
      states[1].add_transition('a', states[2])
      states[1].add_transition('b', states[3])
      states[2].add_transition('a', states[0])
      states[3].add_transition('a', states[0])
      @other.mark_accept_state(states[2])
      @other.mark_accept_state(states[3])
      
      @result = @automaton.import_states_from_automaton(@other)
    end
    
    def check_built_correctly(start_state, automaton)
      automaton.accept_state?(start_state).should be_false
      start_state.transitions['b'].should be_empty
      start_state.transitions['a'].length.should == 1
      
      state = start_state.transitions['a'].first
      automaton.accept_state?(state).should be_false
      state.transitions['a'].length.should == 1
      state.transitions['b'].length.should == 1
      
      end_state_one = state.transitions['a'].first
      end_state_one.transitions['b'].should be_empty
      end_state_one.transitions['a'].length.should == 1
      end_state_one.transitions['a'].first.should == start_state
      
      end_state_two = state.transitions['b'].first
      end_state_two.transitions['b'].should be_empty
      end_state_two.transitions['a'].length.should == 1
      end_state_two.transitions['a'].first.should == start_state
    end
      
    it "shouldn't modify the parameter" do
      @other.states.length.should == 4
      @other.accept_states.length.should == 2
      check_built_correctly(@other.start_state, @other)
    end
    
    it "should contain all the states that were present in the parameter" do
      @other.states.each do |state|
        @result[state].should_not be_nil
      end
    end
    
    it "should correctly build all the transitions that were present in the parameter" do
      start_state = @result[@other.start_state]
      check_built_correctly(start_state, @automaton)
    end
    
    it "shouldn't change the start state" do
      @automaton.start_state.should == @original_start_state
    end
    
    it "shouldn't change the accept state list" do
      @automaton.accept_states == @original_accept_states
    end
      
  end
end
