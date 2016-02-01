module Instructions
  module Stack
    def on_push
      @stack.push(pop_next_instruction)
    end

    def on_pop
      value = @stack.pop
      puts "DEBUG #{curr_pc}: popped #{value}"
      @registers.a = value
    end

    def on_double_on_stack
      @stack.push(@stack.last)
    end
  end
end
