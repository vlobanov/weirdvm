class SimpleValue < BytecodeGenerator
  def bytecode
    [PUSH, @value]
  end

  def initialize(value)
    @value = value
  end
end
