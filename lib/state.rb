# encoding: utf-8
# Represents a state in a (nondeterministic) finite automaton.
class State
  def initialize(alphabet)
    @alphabet = Set.new(alphabet)
    @transitions = {}
    alphabet.each do |symbol|
      @transitions[symbol] = self
    end
  end
  
  def transition(symbol)
    @transitions[symbol]
  end
  
  def change_transition(symbol, new_state)
    if incompatible_symbol?(symbol)
      raise "Symbol '#{symbol}' not in state's alphabet"
    elsif incompatible_state?(new_state)
      raise "States have uncompatible alphabets"
    else
      @transitions[symbol] = new_state
    end
  end
  
  def incompatible_symbol?(symbol)
    !@alphabet.include?(symbol)
  end
  
  def incompatible_state?(other)
    self.alphabet != other.alphabet
  end

protected
  attr_reader :alphabet
end
