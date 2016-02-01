class LocalGetOperation < BytecodeGenerator
  def initialize(local_id)
    @local_id = local_id
  end

  def bytecode
    [LLOAD, @local_id]
  end
end
