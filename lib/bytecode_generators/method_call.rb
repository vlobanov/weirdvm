class MethodCall < BytecodeGenerator
  def initialize(method_name, args)
    @method_name = method_name
    @args = args
  end

  def bytecode
    @args.flat_map(&:bytecode) +
      [CALL_METHOD, @method_name]
  end
end
