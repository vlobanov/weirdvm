class LocalSetOperation < BytecodeGenerator
  def initialize(local_id, value)
    @local_id = local_id
    @value = value
  end

  def bytecode
    @value.bytecode + [LSTORE, @local_id]
  end
end
