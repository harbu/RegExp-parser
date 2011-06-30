# encoding: utf-8
# Runs an finite automaton against a given string

module Automaton
  class AutomatonRunner
    def initialize(automaton)
      @automaton = automaton
    end
    
    def run(string)
      if @automaton.start_state.nil?
        false
      else
        traverse(string, @automaton.start_state)
      end
    end
    
  private
    def traverse(string, state)
      if string.empty?
        if @automaton.accept_state?(state)
          true
        else
          traverse_epsilon(string, state)
        end
      else
        traverse_symbol(string, state) || traverse_epsilon(string, state)
      end
    end
    
    def traverse_symbol(string, state)
      symbol = string[0]
      res = state.transitions[symbol].find do |next_state|
        traverse(string[1..-1], next_state)
      end
    end
    
    def traverse_epsilon(string, state)
      state.transitions[:epsilon].find do |next_state|
        traverse(string, next_state)
      end
    end
  end
end
