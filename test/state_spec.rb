# encoding: utf-8
require 'state'

describe State, "on instantiation" do
  it "should have a transition to itself for all alphabet symbols" do
    state = State.new ['a','b']
    state.transition('a').should == state
    state.transition('b').should == state
  end
end

describe State, "when assigning transitions" do
  it "should raise an exception if given a symbol that doesn't belong to its alphabet" do
    state = State.new ['a', 'b']
    lambda { state.change_transition('c', state) }.should
      raise_error RuntimeError, "Symbol 'c' not in state's alphabet"
  end
  
  it "should raise an exception if given a state that has a different alphabet" do
    state = State.new ['a', 'b']
    state_two = State.new ['a', 'b', 'c']
    lambda { state.change_transition('a', state_two) }.should
      raise_error RuntimeError, "States have uncompatible alphabets"
  end
  
  it "should successfully change transitions on valid arguments" do
    state = State.new ['a', 'b']
    state_two = State.new ['b', 'a']
    state.change_transition('b', state_two)
    state.transition('b').should == state_two
  end
    
end
