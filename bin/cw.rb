require_relative "../lib/options"

options = Options.new()
options.parse(ARGV)
if options.interactive? then
  puts("Interactive")
else
  puts("Not Interactive")
end

