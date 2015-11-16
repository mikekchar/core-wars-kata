require_relative "../lib/options"

options = Options.new()
options.parse()
if options.interactive? then
  puts("Interactive")
else
  puts("Not Interactive")
end

