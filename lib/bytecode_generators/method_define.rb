class MethodDefine < BytecodeGenerator
  attr_reader :method_name
  attr_reader :args_n

  def initialize(method_name, args, code)
    @method_name = method_name
    @args = args
    @args_n = args.count
    @code = code
  end

  def bytecode
    finish_with = @method_name == "main" ? [HALT] : [RETURN]
    loading = (0...@args_n).to_a.reverse.flat_map{ |loc_id| [LSTORE, loc_id] }
    [SET_POINT, @method_name] +
      loading +
      @code.bytecode +
      finish_with
  end
end
