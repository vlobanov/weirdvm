class OperationsSequence < BytecodeGenerator
  def initialize(ops)
    @ops = ops
  end

  def bytecode
    @ops.map(&:bytecode).flatten
  end
end
