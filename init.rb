$LOAD_PATH << File.expand_path('../lib', __FILE__)
$LOAD_PATH << File.expand_path('..', __FILE__)

require 'instructions'
require 'program'

class BytecodeGenerator
end

Dir.glob("./lib/bytecode_generators/*.rb") { |f| require f }
