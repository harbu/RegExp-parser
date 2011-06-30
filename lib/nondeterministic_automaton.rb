# encoding: utf-8
# Represents a nondeterministic finite automaton (NFA) capable of expressing all
# regular languages.

require 'set'
require 'state'

module Automaton
  class NondeterministicAutomaton
    attr_reader :states, :start_state, :accept_states, :alphabet
    
    def initialize(alphabet = ('a'..'z'))
      @alphabet = Set.new(alphabet)
      @states = []
      @accept_states = []
    end
    
    def add_state
      @states << State.new(self)
      @start_state ||= @states.last
      @states.last
    end
    
    def start_state=(state)
      validate(state)
      @start_state = state
    end
    
    def mark_accept_state(state)
      validate(state)
      @accept_states << state
    end
    
    def accept_state?(state)
      @accept_states.include?(state)
    end
    
    def compatible_symbol?(symbol)
      @alphabet.include?(symbol) || symbol == :epsilon
    end
    
    def import_states_from_automaton(automaton)
      @visited = Hash.new(nil)
      copy_states(automaton.start_state)
      @visited
    end
    
  private
    def validate(state)
      raise "state not present in automaton" unless @states.include?(state)
    end
    
    def copy_states(state)
      if !@visited[state]
        @visited[state] = self.add_state
        state.transitions.each do |symbol, target_states|
          target_states.each do |target_state|
            @visited[state].add_transition(symbol, copy_states(target_state))
          end
        end
      end
      @visited[state]
    end
  end
end
