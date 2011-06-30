# encoding: utf-8
# Represents a state in a (nondeterministic) finite automaton.

module Automaton
  class State
    def initialize(automaton)
      @automaton = automaton
      @transitions = Hash.new {|hash, key| hash[key] = Set.new } 
    end
    
    def transitions
      @transitions
    end
    
    def add_transition(symbol, new_state)
      raise "Symbol not in state's alphabet" unless @automaton.compatible_symbol?(symbol)
      raise "States have different automata" unless compatible_state?(new_state)
      @transitions[symbol] << new_state
    end
    
    def compatible_state?(other)
      self.automaton == other.automaton
    end

  protected
    attr_reader :automaton
  end
end
