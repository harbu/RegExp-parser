# encoding: utf-8
class State
  attr_reader :alphabet
  def initialize(alphabet)
    @alphabet = alphabet
    @transitions = {}
    alphabet.each do |symbol|
      @transitions[symbol] = self
    end
  end
  def transition(symbol)
    @transitions[symbol]
  end
  def change_transition(symbol, new_state)
    if !@alphabet.include?(symbol)
      raise "States have uncompatible alphabets"
    elsif self.alphabet == new_state.alphabet
      raise "Symbol '#{symbol}' not in state's alphabet"
    else
      @transitions[symbol] = new_state
    end
  end
end
