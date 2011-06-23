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
    if @start_state.nil?
      @start_state = @states.last
    else
      @states.last
    end
  end
  
  def start_state=(state)
    if !@states.include?(state)
      raise "state not present in automaton"
    else
      @start_state = state
    end
  end
end
