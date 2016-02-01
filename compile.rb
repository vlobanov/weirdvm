require_relative './init.rb'

program = Program.new(instructions)
program.run until program.halted?
