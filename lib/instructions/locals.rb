module Instructions
  module Locals
    def on_lload
      local_id = pop_next_instruction
      value = current_frame_locals[local_id]
      @stack.push(value)
    end

    def on_lstore
      local_id = pop_next_instruction
      value = @stack.pop
      current_frame_locals[local_id] = value
    end
  end
end
