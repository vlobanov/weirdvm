class ComputedValue < BytecodeGenerator
  OPERATIONS = {
    :+ => ADD,
    :* => MUL,
  }

  def initialize(operation, arguments)
    @operation = operation
    @arguments = arguments
  end

  def bytecode
    args_code = @arguments.map(&:bytecode).flatten
    compile_operation(@operation, args_code)
  end

  def compile_operation(operation, arguments_prep)
    op_code = OPERATIONS.fetch(operation) { fail "unknown op #{operation}" }
    arguments_prep << op_code
  end
end
