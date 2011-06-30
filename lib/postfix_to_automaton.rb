# encoding: utf-8
# Builds a nondeterministic finite automaton (NFA) from the given regular
# expression, which is in postfix format.

require 'nondeterministic_automaton'

class PostfixToAutomaton
  attr_reader :automaton
  
  def initialize(postfix)
    @postfix = postfix
    @automaton = build_automaton
  end

private
  def build_automaton
    stack = []
    
    @postfix.each_char do |char|
      operand = case char
        when '*' then repetition(stack)
        when '.' then catenation(stack)
        when '|' then alternation(stack)
        else
          automaton = Automaton::NondeterministicAutomaton.new
          start_state = automaton.add_state
          end_state = automaton.add_state
          start_state.add_transition(char, end_state)
          automaton.mark_accept_state(end_state)
          automaton
      end
      stack.push(operand)
    end
    raise "unbalanced expression" unless stack.size == 1
    stack.pop
  end
  
  def repetition(stack)
    automaton = stack.pop
    old_start_state = automaton.start_state
    new_start_state = automaton.add_state
    
    automaton.start_state = new_start_state
    automaton.mark_accept_state(new_start_state)
    new_start_state.add_transition(:epsilon, old_start_state)
    
    automaton.accept_states.each do |end_state|
      end_state.add_transition(:epsilon, old_start_state)
    end
    automaton
  end
  
  def catenation(stack)
    automaton_one = stack.pop
    automaton_two = stack.pop
    equivalents = automaton_one.import_states_from_automaton(automaton_two)
    
    automaton_two.accept_states.each do |accept_state|
      equivalents[accept_state].add_transition(:epsilon, automaton_one.start_state)
    end
    automaton_one.start_state = equivalents[automaton_two.start_state]
    automaton_one
  end
  
  def alternation(stack)
    automaton_one = stack.pop
    automaton_two = stack.pop
    equivalents = automaton_one.import_states_from_automaton(automaton_two)
    
    automaton_two.accept_states.each do |accept_state|
      automaton_one.mark_accept_state(equivalents[accept_state])
    end
    
    new_start_state = automaton_one.add_state
    new_start_state.add_transition(:epsilon, automaton_one.start_state)  
    new_start_state.add_transition(:epsilon, equivalents[automaton_two.start_state])
    automaton_one.start_state = new_start_state
    automaton_one
  end
end
