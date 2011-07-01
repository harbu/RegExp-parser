# encoding: utf-8
# Represents a nondeterministic finite automaton (NFA) capable of expressing all
# regular languages.

require 'set'
require 'state'

module Automaton
  class FiniteAutomaton
    attr_reader :states, :start_state, :accept_states
    
    def initialize
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
        copy_transitions(state)
      end
      @visited[state]
    end
    
    def copy_transitions(mirror_state)
      state = @visited[mirror_state]
      mirror_state.transitions.each do |symbol, end_states|
        end_states.each do |end_state|
          state.add_transition(symbol, copy_states(end_state))
        end
      end
    end
  end
end
