# encoding: utf-8
# Builds finite automata from postfix regular expressions

require 'finite_automaton'

class PostfixToAutomaton
  attr_reader :automaton
  
  def initialize(postfix)
    @postfix = postfix
    @automaton = build_automaton
  end

private
  def build_automaton
    if @postfix == :epsilon
      symbol(:epsilon)
    elsif @postfix.empty?
      Automaton::FiniteAutomaton.new
    else
      build_automaton_from_postfix
    end
  end
  
  def build_automaton_from_postfix
    stack = []
    @postfix.each_char do |char|
      operand = case char
        when '*' then repetition(stack)
        when '.' then catenation(stack)
        when '|' then alternation(stack)
        else symbol(char)
      end
      stack.push(operand)
    end
    raise "unbalanced expression" unless stack.size == 1
    stack.pop
  end
  
  def repetition(stack)
    automaton = stack.pop
    old_start = automaton.start_state
    automaton.start_state = automaton.add_state
    
    automaton.mark_accept_state(automaton.start_state)
    automaton.start_state.add_transition(:epsilon, old_start)
    
    automaton.accept_states.each do |accept_state|
      accept_state.add_transition(:epsilon, old_start)
    end
    automaton
  end
  
  def catenation(stack)
    automaton_right = stack.pop
    automaton_left = stack.pop
    equivalents = automaton_right.import_states_from_automaton(automaton_left)
    
    automaton_left.accept_states.each do |accept_state|
      equivalents[accept_state].add_transition(:epsilon, automaton_right.start_state)
    end
    automaton_right.start_state = equivalents[automaton_left.start_state]
    automaton_right
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
  
  def symbol(char)
    automaton = Automaton::FiniteAutomaton.new
    start_state = automaton.add_state
    end_state = automaton.add_state
    start_state.add_transition(char, end_state)
    automaton.mark_accept_state(end_state)
    automaton
  end
end
