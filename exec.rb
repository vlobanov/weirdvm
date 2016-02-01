class SimpleValue
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

class ComputedValue
  OPERATIONS = {
    :+ => ->(a, b) { a + b },
    :- => ->(a, b) { a - b },
    :* => ->(a, b) { a * b },
    :/ => ->(a, b) { a / b },
  }

  def initialize(operation, arguments)
    @operation = operation
    @arguments = arguments
  end

  def value
    exec_operation(@operation, @arguments.map(&:value))
  end

  def exec_operation(operation, arguments)
    op_action = OPERATIONS.fetch(operation) { fail "unknown op #{operation}" }
    op_action.call(*arguments)
  end
end

def Value(v)
  case v
  when ComputedValue then v
  else SimpleValue.new(v)
  end
end

def c(f, *args)
  ComputedValue.new(f, args.map(&method(:Value)))
end

p c(
  :+, 10, c(
    :*, 3, 11
  )
).value