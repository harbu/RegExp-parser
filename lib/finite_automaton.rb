# encoding: utf-8
# Represents a nondeterministic finite automaton (NFA) capable of expressing all
# regular languages.

require 'set'
require 'state'

class FiniteAutomaton
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
    raise "state not present in automaton" unless @states.include?(state)
    @start_state = state
  end
end
