# encoding: utf-8
# Represents a state in a (nondeterministic) finite automaton.
class State
  def initialize(alphabet)
    @alphabet = Set.new(alphabet)
    @transitions = {}
    alphabet.each {|symbol| @transitions[symbol] = self }
  end
  
  def transition(symbol)
    @transitions[symbol]
  end
  
  def change_transition(symbol, new_state)
    raise "Symbol not in state's alphabet" unless compatible_symbol?(symbol)
    raise "States have uncompatible alphabets" unless compatible_state?(new_state)
    @transitions[symbol] = new_state
  end
  
  def compatible_symbol?(symbol)
    @alphabet.include?(symbol)
  end
  
  def compatible_state?(other)
    self.alphabet == other.alphabet
  end

protected
  attr_reader :alphabet
end
