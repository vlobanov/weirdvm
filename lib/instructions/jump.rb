module Instructions
  module Jump
    def on_jump
      set_pc(
        find_point(
          pop_next_instruction
        )
      )
    end

    def jump_by_compare(compare_method)
      jump_to = find_point(pop_next_instruction)
      value_1 = @stack.pop
      value_2 = @stack.pop
      res = value_1.send(compare_method, value_2)
      set_pc(jump_to) if res
    end

    def on_call_method
      p "calling as hard as I can"
      push_call_stack_return_frame(curr_pc + 1)
      jump_to = find_point(pop_next_instruction)
      set_pc(jump_to)
    end

    def on_return
      return_to_upper_frame
    end

    def on_jump_eql
      jump_by_compare(:==)
    end

    def on_jump_gre
      jump_by_compare(:>=)
    end

    def on_jump_gr
      jump_by_compare(:>)
    end

    def on_jump_lse
      jump_by_compare(:<=)
    end

    def on_jump_ls
      jump_by_compare(:<)
    end
  end
end
