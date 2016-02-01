module Instructions
  module Arithmetics
    def on_add
      value_1 = @stack.pop
      value_2 = @stack.pop
      sum = value_1 + value_2
      @stack.push(sum)
    end

    def on_mul
      value_1 = @stack.pop
      value_2 = @stack.pop
      mul = value_1 * value_2
      @stack.push(mul)
    end

    def on_inc
      @stack.push(@stack.pop + 1)
    end

    def on_dec
      @stack.push(@stack.pop - 1)
    end
  end
end
