# encoding: utf-8
# Runs an finite automaton against a given string

module Automaton
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
        traverse(string, @automaton.start_state)
      end
    end
    
  private
    def string_compatible?(string)
      string.chars.to_a.uniq.all? {|symbol| @automaton.compatible_symbol?(symbol) }
    end
    
    def traverse(string, state)
      if string.empty?
        if @automaton.accept_state?(state)
          true
        else
          state.transitions[:epsilon].find do |next_state|
            traverse(string, next_state)
          end
        end
      else
        symbol = string[0]
        res1 = state.transitions[:epsilon].find do |next_state|
          traverse(string, next_state)
        end
        res2 = state.transitions[symbol].find do |next_state|
          traverse(string[1..-1], next_state)
        end
        res1 || res2
      end
    end
  end
end
