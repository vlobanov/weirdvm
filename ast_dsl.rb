require_relative './init.rb'

class ASTDSL
  attr_reader :sequence

  def initialize(&block)
    @locals = @locals_counter = :not_in_method
    @methods = []
    self.instance_exec(&block)

    @sequence = seq(
      *@methods,
      call_method("main")
    )
  end

  def assert_method_call(method_name, args)
    method = @methods.find{ |m| m.method_name == method_name }
    fail "method #{method_name} not found" unless method

    unless method.args_n == args.count
      fail "method #{method_name} expected #{method.args_n} args, given #{args.count}"
    end
  end

  def c(f, *args)
    ComputedValue.new(f, args.map(&method(:Value)))
  end

  def loc(name)
    fail "undefined local #{name}" unless @locals[name]
    local_id = @locals[name]
    LocalGetOperation.new(local_id)
  end

  def locs(name, value)
    unless @locals[name]
      @locals[name] = @locals_counter
      @locals_counter += 1
    end
    local_id = @locals[name]
    LocalSetOperation.new(local_id, Value(value))
  end

  def seq(*ops)
    OperationsSequence.new(to_values(ops))
  end

  def call_method(method_name, *args)
    assert_method_call(method_name, args)

    MethodCall.new(method_name, to_values(args))
  end

  def to_values(collection)
    collection.map(&method(:Value))
  end

  def defmethod(method_name, *args, &code_seq_block)
    fail "nested method definition in #{@current_method}" if @current_method

    @current_method = method_name

    @locals = {}
    @locals_counter = 0

    args.each do |arg|
      @locals[arg] = @locals_counter
      @locals_counter += 1
    end

    method_code = self.instance_exec(&code_seq_block)
    @current_method = nil
    @locals = @locals_counter = :not_in_method
    puts "method_code:"
    p method_code
    @methods << MethodDefine.new(method_name, args, method_code)
  end

  def Value(v)
    case v
    when BytecodeGenerator then v
    else SimpleValue.new(v)
    end
  end
end

ast = ASTDSL.new do
  defmethod("main_plus", "b_value", "a_value") do
    seq(
      c(:+, loc("b_value"), loc("a_value"))
    )
  end

  defmethod("main_mul", "c_value", "d_value") do
    seq(
      locs("result",
        c(:*, loc("d_value"), loc("c_value"))
      ),
      c(:*, loc("result"), 100)
    )
  end

  defmethod("main") do
    seq(
      # call_method("main_plus", 10, 15)
      # c(:+, 1, 2)
      locs("premature", 8000),
      c(:+,
        c(:+, call_method("main_plus", 10, 15),
              call_method("main_mul",  3, 11)),
        loc("premature"))
    )
  end
end

def bytecode_pprint(bc)
  bc.each_with_index do |c, i|
    is_command = c.is_a? Symbol
    puts if is_command
    puts if c == :set_point
    c_number = is_command ? "#{i}: " : ""
    print "#{c_number}#{c.inspect} "
  end
  puts
  puts
end

instructions = ast.sequence.bytecode

bytecode_pprint instructions
puts
puts "================================================"
puts
program = Program.new(instructions)
program.run until program.halted?
