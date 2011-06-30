# encoding: utf-8

require 'automaton_runner'
require 'finite_automaton'

describe Automaton::AutomatonRunner do
  before(:each) do
    @automaton = Automaton::FiniteAutomaton.new ['a', 'b']
    @runner = Automaton::AutomatonRunner.new(@automaton)
  end
  
  describe "with incomplete automaton" do
    it "should throw exception if string contains uncompatible symbols" do
      lambda { @runner.run("abcba") }.should raise_error RuntimeError,
          "string contains symbols not present in automata's alphabet"
    end
    
    it "should reject if no states" do
      @runner.run("abba").should be_false
    end
    
    it "should reject if set of accept states is empty" do
      @automaton.add_state
      @runner.run("abba").should be_false
    end
  end
  
  describe "with a DFA containing exactly one accept state" do
    before(:each) do
      state = @automaton.add_state
      state.add_transition('a', state)
      state.add_transition('b', state)
      @automaton.mark_accept_state(state)
    end
    
    it "should accept empty string" do
      @runner.run("").should be_true
    end
    
    it "should accept any string of valid symbols" do
      @runner.run("a").should be_true
      @runner.run("bbbbaaa").should be_true
      @runner.run("abaababababa").should be_true
    end
  end
  
  describe "with a DFA containing one accept and one reject state" do
    before(:each) do
      accept = @automaton.add_state
      reject = @automaton.add_state
      accept.add_transition('a', reject);
      accept.add_transition('b', accept);
      reject.add_transition('a', accept);
      reject.add_transition('b', accept);
      @automaton.mark_accept_state(accept)
    end
    
    it "should accept any string that finishes on accept state" do
      @runner.run("").should be_true
      @runner.run("bbbbbb").should be_true
      @runner.run("bbabaa").should be_true
    end
    
    it "should reject any string that finishes on reject state" do
      @runner.run("a").should be_false
      @runner.run("baaabbbba").should be_false
    end
  end
  
  describe "with a NFA missing some symbol transitions" do
    before(:each) do
      reject = @automaton.add_state
      accept = @automaton.add_state
      reject.add_transition('b', accept)
      reject.add_transition('b', reject)
      accept.add_transition('a', reject)
      @automaton.mark_accept_state(accept)
    end
    
    it "should reject any string that falls out of all current states" do
      @runner.run("baaa").should be_false
    end
    
    it "should accept any string that ends with at least one accept state" do
      @runner.run("bbbb").should be_true
    end
  end
  
  describe "with a NFA having epsilon transitions" do
    before(:each) do 
      states = 5.times.collect { @automaton.add_state }
      states[0].add_transition(:epsilon, states[1])
      states[1].add_transition(:epsilon, states[2])
      states[2].add_transition('a', states[3])
      states[3].add_transition(:epsilon, states[4])
      @automaton.mark_accept_state(states[4])
    end
    
    it "should accept any valid string" do
      @runner.run("a").should be_true
    end
  end
      
end
