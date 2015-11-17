require_relative "../lib/options"
require_relative "../lib/command_line"

options = Options.new()
options.parse(ARGV)
if options.interactive? then
  cl = CommandLine.new("> ")
  while buf = cl.read
    p buf
  end
else
  puts("Nothing to do")
end

