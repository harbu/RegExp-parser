# encoding: utf-8

require 'set'
require 'state'

describe Automaton::State do
  before(:each) do
    @state = Automaton::State.new ['a', 'b']
  end
  
  describe "on instantiation" do
    it "should have a transition to itself for all alphabet symbols" do
      @state.transition('a').should == @state
      @state.transition('b').should == @state
    end
  end

  describe "when assigning transitions" do
    it "should raise an exception if given a symbol that doesn't belong to its alphabet" do
      lambda { @state.change_transition('c', @state) }.should raise_error RuntimeError, "Symbol not in state's alphabet"
    end
    
    it "should raise an exception if given a state that has a different alphabet" do
      state_two = Automaton::State.new ['a', 'b', 'c']
      lambda { @state.change_transition('a', state_two) }.should raise_error RuntimeError, "States have uncompatible alphabets"
    end
    
    it "should successfully change transitions on valid arguments" do
      state_two = Automaton::State.new ['b', 'a']
      @state.change_transition('b', state_two)
      @state.transition('b').should == state_two
    end
  end
end


