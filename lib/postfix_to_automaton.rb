# encoding: utf-8
# Builds a nondeterministic finite automaton (NFA) from the given regular
# expression, which is in postfix format.

require 'nondeterministic_automaton'

class PostfixToAutomaton
  attr_reader :automaton
  
  def initialize(postfix)
    @postfix = postfix
    build_automaton
  end

private
  def build_automaton
    stack = []
    
    @postfix.each_char do |char|
      stack.push = case char
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
    end
    @automaton.mark_accept_state(state)
  end
  
  def repetition(stack, state)
    automaton = stack.pop
    old_start_state = automaton.start_state
    new_start_state = automaton.add_state
    
    automaton.start_state = new_start_state
    automaton.mark_accept_state(new_start_state)
    new_start_state.add_transition(:epsilon, old_start_state)
    
    automaton.accept_states.each do |end_state|
      end_state.add_transition(:epsilon, old_start_state)
    end
  end
  
  def catenation(stack, state)
    right_operand = stack.pop
    left_operand = stack.pop
    
    middle_state = @automaton.add_state
    last_state = @automaton.add_state
    
    state.add_transition(left_operand, middle_state)
    middle_state.add_transition(right_operand, last_state)
    last_state
  end
  
  def alternation(stack, state)
    right_operand = stack.pop
    left_operand = stack.pop
    
    middle_states = 2.times.collect { @automaton.add_state }
    last_state = @automaton.add_state
    
    state.add_transition(:epsilon, middle_states.first)
    state.add_transition(:epsilon, middle_states.last)
    middle_states.first.add_transition(left_operand, last_state)
    middle_states.last.add_transition(right_operand, last_state)
    last_state
  end
  
  def automaton
    automaton = Automaton::NondeterministicAutomaton.new
    start_state = automaton.add_state
    accept_state = automaton.add_state
    automaton.mark_accept_state(accept_state)
    
    if @postfix.length == 1
      start_state.add_transition(@postfix[0], accept_state)
    elsif @postfix.length == 2
      middle_state = automaton.add_state
      start_state.add_transition(:epsilon, accept_state)
      start_state.add_transition(@postfix[0], middle_state)
      middle_state.add_transition(:epsilon, start_state)
    elsif @postfix.length == 3
      if @postfix[2] == "."
        middle_state = automaton.add_state
        start_state.add_transition(@postfix[0], middle_state)
        middle_state.add_transition(@postfix[1], accept_state)
      else
        middle_state_one = automaton.add_state
        middle_state_two = automaton.add_state
        start_state.add_transition(:epsilon, middle_state_one)
        start_state.add_transition(:epsilon, middle_state_two)
        middle_state_one.add_transition(@postfix[0], accept_state)
        middle_state_two.add_transition(@postfix[1], accept_state)
      end
    end
    automaton
  end
end
