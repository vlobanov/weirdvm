require 'instructions/jump'
require 'instructions/stack'
require 'instructions/arithmetics'
require 'instructions/locals'

class Program
  include Instructions::Jump
  include Instructions::Stack
  include Instructions::Arithmetics
  include Instructions::Locals

  Registers = Struct.new(:a, :b, :c, :d, :e, :f, :pc, :sp)

  CallStackFrame = Struct.new(:locals, :return_pointer) do
    def inspect
      "<#FRAME return_pointer=#{return_pointer} locals=#{locals}>"
    end
  end

  def initialize(instructions)
    @instructions = instructions
    @halted = false
    @stack = []
    @call_stack = [CallStackFrame.new([], :nowhere_to_return)]
    @points = {}
    @registers = Registers.new(
      0, 0, 0, 0, 0, 0,
      0, 0
    )
    @locals = []
    find_points!

    set_pc(find_point("main") - 1)
  end

  def halted?
    @halted
  end

  def eval(instruction)
    p "EVAL pc=#{curr_pc}:: #{instruction}"
    self.send(:"on_#{instruction}")
  end

  def run
    eval(@instructions[curr_pc])
    increment_pc
  end

private

  def curr_pc
    @registers.pc
  end

  def increment_pc
    @registers.pc += 1
  end

  def set_pc(value)
    @registers.pc = value
  end

  def current_frame_locals
    @call_stack.last.locals
  end

  def find_points!
    @instructions.each_with_index do |instruction, pc|
      if instruction == SET_POINT
        point_name = @instructions[pc + 1]
        point_to = pc + 1
        puts "DEBUG setting point #{point_name} -> #{point_to} (#{@instructions[point_to]})"
        @points[point_name] = point_to
      end
    end
  end

  def pop_next_instruction
    @instructions[increment_pc]
  end

  def on_halt
    @halted = true
    puts "halted. stack = #{@stack}"
  end

  def on_set_point
    # points are already processed,
    # just skip point name also
    pop_next_instruction
  end

  def find_point(point_name)
    @points.fetch(point_name) { fail "point #{point_name} not found" }
  end

  def on_mov
    move_from = pop_next_instruction
    move_to = pop_next_instruction
    @registers[move_to] = @registers[move_from]
  end

  def on_whatsup
    p "WHATSUP MAN? curr pc = #{curr_pc}; registers = #{@registers}; stack = #{@stack}"
  end

  def push_call_stack_return_frame(return_to)
    @call_stack.push(
      CallStackFrame.new([], return_to)
    )
  end

  def return_to_upper_frame
    p "current call stack: "
    p @call_stack
    return_to = @call_stack.pop.return_pointer
    set_pc(return_to)
  end
end
