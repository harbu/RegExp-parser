# encoding: utf-8
# Runs an finite automaton against a given string
class AutomatonRunner
  def initialize(automaton)
    @automaton = automaton
  end
  
  def run(string)
    unless string_compatible?(string)
      raise "string contains symbols not present in automata's alphabet"
    end
    if @automaton.start_state.nil?
      false
    else
      traverse(string)
    end
  end
  
private
  def string_compatible?(string)
    string.chars.to_a.uniq.all? {|symbol| @automaton.compatible_symbol?(symbol) }
  end
  
  def traverse(string)
    state = @automaton.start_state
    string.each_char {|symbol| state = state.transition(symbol) }
    @automaton.accept_state?(state)
  end
end
