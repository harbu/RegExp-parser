# encoding: utf-8

require 'automaton_runner'
require 'nondeterministic_automaton'

describe Automaton::AutomatonRunner do
  before(:each) do
    @automaton = Automaton::NondeterministicAutomaton.new ['a', 'b']
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
      @runner.run("ba").should be_false
    end
  end
end
