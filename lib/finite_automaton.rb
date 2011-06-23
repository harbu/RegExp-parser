# encoding: utf-8

# Represents a nondeterministic finite automaton (NFA) capable of expressing all
# regular languages.
class FiniteAutomaton
  attr_reader :states, :start_state, :accept_states, :alphabet
  def initialize(alphabet = ('a'..'z'))
    @alphabet = alphabet
    @states = []
    @accept_states = []
  end
end
