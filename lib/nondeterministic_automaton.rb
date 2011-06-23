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
      @states << State.new(@alphabet)
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
      @alphabet.include?(symbol)
    end
    
  private
    def validate(state)
      raise "state not present in automaton" unless @states.include?(state)
    end
  end
end
